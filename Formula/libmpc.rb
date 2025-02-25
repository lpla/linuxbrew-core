class Libmpc < Formula
  desc "C library for the arithmetic of high precision complex numbers"
  homepage "http://www.multiprecision.org/mpc/"
  url "https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/mpc/mpc-1.2.1.tar.gz"
  sha256 "17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "8c037df4b551058d00351676dc2c5ec395bd69c88545fac9ccfd0749dadb8ee2" => :catalina
    sha256 "c229b6def61f4acc41b4b159d93dbc63a5c77f87f61623c9f7c5399da440cc4f" => :mojave
    sha256 "939f0ad01d809356e33bdc70a8a8483eb1b021fd5f3723d0e61a2698af00f01b" => :high_sierra
    sha256 "c12f0406fb375c08d4c9f699ec2d28099088bb999fe9cceefe9145c001f24f89" => :x86_64_linux
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpc.h>
      #include <assert.h>
      #include <math.h>

      int main() {
        mpc_t x;
        mpc_init2 (x, 256);
        mpc_set_d_d (x, 1., INFINITY, MPC_RNDNN);
        mpc_tanh (x, x, MPC_RNDNN);
        assert (mpfr_nan_p (mpc_realref (x)) && mpfr_nan_p (mpc_imagref (x)));
        mpc_clear (x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["mpfr"].opt_lib}",
                   "-L#{Formula["gmp"].opt_lib}", "-lmpc", "-lmpfr",
                   "-lgmp", "-o", "test"
    system "./test"
  end
end
