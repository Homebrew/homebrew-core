class Solid < Formula
  desc "Collision detection library for geometric objects in 3D space"
  homepage "http://www.dtecta.com/"
  url "http://www.dtecta.com/files/solid-3.5.6.tgz"
  sha256 "4acfa20266f0aa5722732794f8e93d7bb446e467719c947a3ca583f197923af0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "879e065025b32017efe1cc1d1fc640f003803dd2031141452fa707a288964100"
    sha256 cellar: :any,                 big_sur:       "537224e4f932680b3ee2e885b3f1215904be16731281284095b543a5ddbe42b1"
    sha256 cellar: :any,                 catalina:      "f5b7baa17975ec35c118f8744fa852d51c07d03b96d707de8ee3e65c19755e9a"
    sha256 cellar: :any,                 mojave:        "8c7fd219da510e1821b50069ffbcc3025bee102a1ada47fe4b3f9464507fb1bc"
    sha256 cellar: :any,                 high_sierra:   "30954dffe6674f98523b3cb299f909aefbe554b70000cd777df75c326edf80d0"
    sha256 cellar: :any,                 sierra:        "2836475cd2195c3906950c2a62ed618302e3f57ba4c348a82b737fcb0956fc07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb9ab57cd86c4d1b5da960ea243a776e1b7a695652bf3cbced579bfcf01c312"
  end

  # This patch fixes a broken build on clang-600.0.56.
  # Was reported to bugs@dtecta.com (since it also applies to solid-3.5.6)
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"

    # exclude the examples from compiling!
    # the examples do not compile because the include statements
    # for the GLUT library are not platform independent
    inreplace "Makefile", " examples ", " "

    system "make", "install"
  end
end

__END__
diff --git a/include/MT/Quaternion.h b/include/MT/Quaternion.h
index 3726b4f..3393697 100644
--- a/include/MT/Quaternion.h
+++ b/include/MT/Quaternion.h
@@ -154,7 +154,7 @@ namespace MT {

		Quaternion<Scalar> inverse() const
		{
-			return conjugate / length2();
+			return conjugate() / length2();
		}

		Quaternion<Scalar> slerp(const Quaternion<Scalar>& q, const Scalar& t) const
diff --git a/src/complex/DT_CBox.h b/src/complex/DT_CBox.h
index 7fc7c5d..16ce972 100644
--- a/src/complex/DT_CBox.h
+++ b/src/complex/DT_CBox.h
@@ -131,4 +131,6 @@ inline DT_CBox operator-(const DT_CBox& b1, const DT_CBox& b2)
                    b1.getExtent() + b2.getExtent());
 }

+inline DT_CBox computeCBox(MT_Scalar margin, const MT_Transform& xform);
+
 #endif
