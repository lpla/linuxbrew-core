class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v3.2/mxml-3.2.tar.gz"
  sha256 "b894f6c64964f2e77902564c17ba00f5d077a7a24054e7c1937903b0bd42c974"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    cellar :any
    sha256 "680142115002908ad936e6cc27b507056d10b91a4c6d5ca250480090be71e21b" => :catalina
    sha256 "a8d373d3bef6a43d40ef8aed433257fbdc6ba7566b454565dcdeeb3b21290edc" => :mojave
    sha256 "6717fbc8fb911a1a3b076c1cb1d80ab9ea010456810d14995346973543cdc2f4" => :high_sierra
    sha256 "e91993d91a285da7674e3cc83bd94624062834aaec343e9a2fc6e69c8f77e979" => :x86_64_linux
  end

  depends_on xcode: :build if OS.mac? # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mxml.h>

      int main()
      {
        FILE *fp;
        mxml_node_t *tree;

        fp = fopen("test.xml", "r");
        tree = mxmlLoadFile(NULL, fp, MXML_OPAQUE_CALLBACK);
        fclose(fp);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmxml", "-o", "test"
    system "./test"
  end
end
