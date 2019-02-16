class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.github.io/"
  url "https://github.com/libspatialindex/libspatialindex/releases/download/1.9.0/spatialindex-src-1.9.0.tar.gz"
  sha256 "52d6875deea12f88e6918d192cbfd38d6e78d13f84e1fd10cca66132fa063941"

  bottle do
    cellar :any
    sha256 "3cffbd33a299a0354849d510cbc7aaa71abdb41fdff3a7d5d0dd3459de2a91fb" => :mojave
    sha256 "76e41dc6e6ccb457cb2db3d6806461e065784bf161864ed4276c8041724ce995" => :high_sierra
    sha256 "6c60b7939a2220b10e04cc5e47a6672935697a13accc1284bb90b401b866044c" => :sierra
    sha256 "34d1e02dd4133ed67a8a4c299044e277e1e9cfc982962c50c44c751723eb85cb" => :el_capitan
    sha256 "907f40e614218622fd9fecc0a542adcdf768446a198ef4cc972b30a7eb5e6cd3" => :yosemite
    sha256 "33e053a03ea77bc87c3aab4f8319461baab56824e3c933cb09398e6df1b542ba" => :mavericks
  end

  def install
    ENV.cxx11

    ENV.append "CXXFLAGS", "-std=c++11"

    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spatialindex/SpatialIndex.h>
      #include <map>

      using namespace SpatialIndex;
      using namespace std;

      /*
      * Test the Geometry
      * Nowhere near complete, but it's something
      */
      int main(int argc, char** argv) {
        //define points
        double c1[2] = {1.0, 0.0};
        double c2[2] = {3.0, 2.0};
        double c3[2] = {2.0, 0.0};
        double c4[2] = {2.0, 4.0};
        double c5[2] = {1.0, 1.0};
        double c6[2] = {2.5, 3.0};
        double c7[2] = {1.0, 2.0};
        double c8[2] = {0.0, -1.0};
        double c9[2] = {4.0, 3.0};
        Point p1 = Point(&c1[0], 2);
        Point p2 = Point(&c2[0], 2);
        Point p3 = Point(&c3[0], 2);
        Point p4 = Point(&c4[0], 2);
        Point p5 = Point(&c5[0], 2);
        Point p6 = Point(&c6[0], 2);
        Point p7 = Point(&c7[0], 2);
        Point p8 = Point(&c8[0], 2);
        Point p9 = Point(&c9[0], 2);

        double c3a[2] = {2.0, 3.0};
        Point p3a = Point(&c3a[0], 2);

        //Now Test LineSegment intersection
        LineSegment ls1 = LineSegment(p1, p2);
        LineSegment ls2 = LineSegment(p3, p4);
        LineSegment ls3 = LineSegment(p3a, p4);

        if (!ls1.intersectsShape(ls2)) {
            cerr << "Test failed:  intersectsShape returned false, but should be true." << endl;
            cerr << ls1 << ", " << ls2 << endl;
            return -1;
        }

        if (ls1.intersectsShape(ls3)) {
            cerr << "Test failed:  intersectsShape returned true, but should be false." << endl;
            cerr << ls1 << ", " << ls3 << endl;
            return -1;
        }

        //Now LineSegment Region intersection
        Region r1 = Region(p5, p6);
        Region r2 = Region(p7, p6);
        Region r3 = Region(p8, p9);

        if (!r1.intersectsShape(ls1) || !ls1.intersectsShape(r1)) {
            cerr << "Test failed:  intersectsShape returned false, but should be true." << endl;
            cerr << r1 << ", " << ls1 << endl;
            return -1;
        }

        if (r2.intersectsShape(ls1) || ls1.intersectsShape(r2)) {
            cerr << "Test failed:  intersectsShape returned true, but should be false." << endl;
            cerr << r2 << ", " << ls1 << endl;
            return -1;
        }

        // This is the contains test
        if (!r3.intersectsShape(ls1) || !ls1.intersectsShape(r3)) {
            cerr << "Test failed:  intersectsShape returned false, but should be true." << endl;
            cerr << r3 << ", " << ls1 << endl;
            return -1;
        }

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lspatialindex", "-o", "test"
    system "./test"
  end
end
