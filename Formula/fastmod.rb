class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.1.tar.gz"
  sha256 "0e0c2d50489c90cb8c8904772be2e9d31353fbed814d9088ee6013c27c2d111b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6416944d1320d2188e05fcb0c725a6aa06d73fd76015414d43a8e21d6efb848a" => :catalina
    sha256 "fd06122965f7b06b05356363c0483c204c8f0053753324d1355720ad2d111249" => :mojave
    sha256 "90c4d5b4217b91c14fa4a7726192960ebf45fc04cd5699ffab9173eed6d6fc35" => :high_sierra
    sha256 "f8007bb5e7a4a3a968d2d08595dea16f391246686deea2d1ede944ff04b4e32f" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"input.txt").write("Hello, World!")
    system bin/"fastmod", "-d", testpath, "--accept-all", "World", "fastmod"
    assert_equal "Hello, fastmod!", (testpath/"input.txt").read
  end
end
