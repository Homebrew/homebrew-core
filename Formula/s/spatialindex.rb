class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.org/"
  url "https://github.com/libspatialindex/libspatialindex/releases/download/2.0.0/spatialindex-src-2.0.0.tar.bz2"
  sha256 "949e3fdcad406a63075811ab1b11afcc4afddc035fbc69a3acfc8b655b82e9a5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "015d8d895f7d70c463c51cc1edbe5947312bba8c02520ed7038847bd72029802"
    sha256 cellar: :any,                 arm64_sonoma:   "d4d8356031dbd364d52f7084eda53904504adb4c2d66cd271eb59724c68c54bb"
    sha256 cellar: :any,                 arm64_ventura:  "18cf32a34ab1ba0b81c809ddcdaee91467b0221cd0175db1fdf859f8f6be237f"
    sha256 cellar: :any,                 arm64_monterey: "45516ebe96f28fd4cc70ee529d7e008b897e4e277aaff5ee7407635134089bd7"
    sha256 cellar: :any,                 sonoma:         "6b452f456423420445266dcec2c67a8ff3d342fc18bce4c280af2148054d4cfe"
    sha256 cellar: :any,                 ventura:        "37c67e12247424a37c681c930ddf5a130fb7f28165c2c10536975dcc7c1c7f98"
    sha256 cellar: :any,                 monterey:       "0cefd42c848e69c6763d45a4eded4b9309ed01a752f284a370d93596e3bc0109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8f43583a9d8c86dcabbe2d332e325c9bf1603ffba4f3344239e23d86b8c8ca"
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
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lspatialindex", "-o", "test"
    system "./test"
  end
end
