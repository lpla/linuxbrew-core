class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.2.2.tar.gz"
  sha256 "92df7d22239b09f7580572305c862da1fb030a97cef7631ba060ac51fa3864cc"
  head "https://github.com/erlang/otp.git"
  revision 1 unless OS.mac?

  bottle do
    cellar :any
    sha256 "1f97cc257f83ba116e77c635611f90bd311044bf10af07503623383ca4b29ed1" => :catalina
    sha256 "aedf30e594f3a938a47ae1069826eb7eeadd29484515457e2a512e62112cc9ff" => :mojave
    sha256 "61ed0ae1bf5b96db049c48b7989e3a55cf3b0b4ed6d364d4ab9a877f7dbf39c8" => :high_sierra
    sha256 "927088e73cd7cf472b5fdb3652e4b45017fd85739289a1aafdc450296527b6e8" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  depends_on "m4" => :build unless OS.mac?

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.1.tar.gz"
    sha256 "64f45909ed8332619055d424c32f8cc8987290a1ac4079269572fba6ef9c74d9"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.1.tar.gz"
    sha256 "3864ac1aa30084738d783d12c241c0a4943cf22a6d1d0f6c7bb9ba0a45ecb9eb"
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
