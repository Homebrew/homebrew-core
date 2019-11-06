class Solid < Formula
  desc "Collision detection library for geometric objects in 3D space"
  homepage "http://www.dtecta.com/"
  url "http://www.dtecta.com/files/solid-3.5.6.tgz"
  sha256 "4acfa20266f0aa5722732794f8e93d7bb446e467719c947a3ca583f197923af0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f5b7baa17975ec35c118f8744fa852d51c07d03b96d707de8ee3e65c19755e9a" => :catalina
    sha256 "8c7fd219da510e1821b50069ffbcc3025bee102a1ada47fe4b3f9464507fb1bc" => :mojave
    sha256 "30954dffe6674f98523b3cb299f909aefbe554b70000cd777df75c326edf80d0" => :high_sierra
    sha256 "2836475cd2195c3906950c2a62ed618302e3f57ba4c348a82b737fcb0956fc07" => :sierra
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
