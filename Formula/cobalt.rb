class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.4.tar.gz"
  sha256 "24b1fde3bdd1c8e6e8aa0e24c37c1bd2821a7e41a8bce4724f0473fd3722c478"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ece5edf627390bd8aa6a7f2b423f1e8fd87122570531edafe8bf7a2c8ef2d917" => :catalina
    sha256 "53d8b9854325201c5a490a912f75489f691e7f0bb8935bbd3d5266d548c4619f" => :mojave
    sha256 "8f4416c77f2c1a20bda2e74cafde341602eefeecc03e81f719e08a1872c2c369" => :high_sierra
    sha256 "e9696d93c0541451fa7aab3b1496dc1816763f3e6fec241e04d3193503471cab" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
