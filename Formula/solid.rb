class Solid < Formula
  desc "Collision detection library for geometric objects in 3D space"
  homepage "http://www.dtecta.com/"
  url "http://www.dtecta.com/files/solid-3.5.6.tgz"
  sha256 "4acfa20266f0aa5722732794f8e93d7bb446e467719c947a3ca583f197923af0"

  bottle do
    cellar :any
    sha256 "4ba23271be7dc1c41419901ee6a0c5195f7ebf773164091225d1220e21ebbccd" => :mojave
    sha256 "010d867aa6dfba7ae6ff9b5aa1a504285d45ccd9b682d512f70bc79cde208f8a" => :high_sierra
    sha256 "a79692fbc3d3c150bedef4cbb5455ca175f9534703da91bc27abaac157f1414d" => :sierra
    sha256 "217b3ce0111e94edfbbae5f82c07d3a8c129e7c5733a7707eb592b80eeb94a75" => :el_capitan
    sha256 "e54bf158f4e91171c55d5514abe6fd36ca358e39e8271985f446be4002b6a5e7" => :yosemite
    sha256 "b22bde511d5fa7a1112ef122fa70e5260ac6491bdfd3f8eeb19848b5b769621d" => :mavericks
    sha256 "db9bd9a409bc447657f759852aa02feb0bc19cd84c552b9c16dfed130c2a3829" => :mountain_lion
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
