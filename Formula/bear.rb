class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.4.4.tar.gz"
  sha256 "5e95c9fe24714bcb98b858f0f0437aff76ad96b1d998940c0684c3a9d3920e82"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "84cf802302f75a97d460d81b34388f1b426739251a0a1ef693798974de8b20bb" => :catalina
    sha256 "cf53da69c793f2eebdfe625ffd6776d4f3a7a36a440eeb027ec75bc27865acad" => :mojave
    sha256 "9e0070f18b84c96e10c0305c016e75129d51b9d480424b12563a1979b2a7e297" => :high_sierra
    sha256 "0753bb79d23c26518595f4bc0e6f51995db59e161c99d2338d43c7246a3705ab" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]
    system "cmake", ".", *args
    system "make", "install"

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
