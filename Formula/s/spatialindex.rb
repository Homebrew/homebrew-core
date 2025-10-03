class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.org/en/latest/"
  url "https://github.com/libspatialindex/libspatialindex/releases/download/2.1.0/spatialindex-src-2.1.0.tar.bz2"
  sha256 "c59932395e98896038d59199f2e2453595df6d730ffbe09d69df2a661bcb619b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b53e1ab281e72ef97d3cedf3e2fccc27d21d8e821b608e6a7e5de0f296153b4"
    sha256 cellar: :any,                 arm64_sequoia: "2a84ec0d1a739824971183632c46cd8e1a6e0c8584e00d4ad1d9460d712ee481"
    sha256 cellar: :any,                 arm64_sonoma:  "071b7e50fbe7ac47aa578e69edc53c87de74808c8287aa937bdaa50de0e3fa97"
    sha256 cellar: :any,                 arm64_ventura: "ccdbb7d96b49d3a30ad83530034142629350a725e64e1cba2e260b41c7ef15d0"
    sha256 cellar: :any,                 sonoma:        "ffd3cfa50eb1ed66c896081d61ce335c968c1f432a95770ffc80233f41ab0571"
    sha256 cellar: :any,                 ventura:       "117276faf402a1afed33a420fc9e59f66434612f4f735e307cc13e3d45669f7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53c0ec9bb0548fba0c58da85496b6da22089392f2c4a3517db8890664c1f52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "359128f10b75e3ef834f3fbc988856b763caddb96bc006302cf2e6d2a9fb2a99"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # write out a small program which inserts a fixed box into an rtree
    # and verifies that it can query it
    (testpath/"test.cpp").write <<~CPP
      #include <spatialindex/SpatialIndex.h>

      using namespace std;
      using namespace SpatialIndex;

      class MyVisitor : public IVisitor {
      public:
          vector<id_type> matches;

          void visitNode(const INode& n) {}
          void visitData(const IData& d) {
              matches.push_back(d.getIdentifier());
          }
          void visitData(std::vector<const IData*>& v) {}
      };

      int main(int argc, char** argv) {
          IStorageManager* memory = StorageManager::createNewMemoryStorageManager();
          id_type indexIdentifier;
          RTree::RTreeVariant variant = RTree::RV_RSTAR;
          ISpatialIndex* tree = RTree::createNewRTree(
              *memory, 0.5, 100, 10, 2,
              variant, indexIdentifier
          );
          /* insert a box from (0, 5) to (0, 10) */
          double plow[2] = { 0.0, 0.0 };
          double phigh[2] = { 5.0, 10.0 };
          Region r = Region(plow, phigh, 2);

          std::string data = "a value";

          id_type id = 1;

          tree->insertData(data.size() + 1, reinterpret_cast<const unsigned char*>(data.c_str()), r, id);

          /* ensure that (2, 2) is in that box */
          double qplow[2] = { 2.0, 2.0 };
          double qphigh[2] = { 2.0, 2.0 };
          Region qr = Region(qplow, qphigh, 2);
          MyVisitor q_vis;

          tree->intersectsWithQuery(qr, q_vis);

          return (q_vis.matches.size() == 1) ? 0 : 1;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lspatialindex", "-o", "test"
    system "./test"
  end
end
