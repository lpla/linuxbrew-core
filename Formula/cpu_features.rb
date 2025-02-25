class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.6.0.tar.gz"
  sha256 "95a1cf6f24948031df114798a97eea2a71143bd38a4d07d9a758dda3924c1932"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba67bb2d2166f43b17aba3fb4f8306b577e17779e8a8facea32a16451c7b369d" => :catalina
    sha256 "9f7d3b134c25934208808a47a8c8ecde61d8a7c3d429246ce807d9183930bd66" => :mojave
    sha256 "057d70560cecfd8863543a562ddb0ec64147ac3ce6292adedf0bc28c74a92349" => :high_sierra
    sha256 "8116fe1bb8805aa7df967e20423af1c49a143d51aab4b97bb58653256eb9e3ff" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match /^arch\s*:/, output
    assert_match /^brand\s*:/, output
    assert_match /^family\s*:/, output
    assert_match /^model\s*:/, output
    assert_match /^stepping\s*:/, output
    assert_match /^uarch\s*:/, output
    assert_match /^flags\s*:/, output
  end
end
