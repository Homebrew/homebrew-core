class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.github.io/"
  url "https://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz"
  sha256 "7caa46a2cb9b40960f7bc82c3de60fa14f8f3e000b02561b36cbf2cfe6a9bfef"

  bottle do
    cellar :any
    sha256 "3cffbd33a299a0354849d510cbc7aaa71abdb41fdff3a7d5d0dd3459de2a91fb" => :mojave
    sha256 "76e41dc6e6ccb457cb2db3d6806461e065784bf161864ed4276c8041724ce995" => :high_sierra
    sha256 "6c60b7939a2220b10e04cc5e47a6672935697a13accc1284bb90b401b866044c" => :sierra
    sha256 "34d1e02dd4133ed67a8a4c299044e277e1e9cfc982962c50c44c751723eb85cb" => :el_capitan
    sha256 "907f40e614218622fd9fecc0a542adcdf768446a198ef4cc972b30a7eb5e6cd3" => :yosemite
    sha256 "33e053a03ea77bc87c3aab4f8319461baab56824e3c933cb09398e6df1b542ba" => :mavericks
    sha256 "401c416f243996ac4f6bca61a871aec7fb8811f8aef6073dfc62c64dfe2650f7" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
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

          tree->insertData(data.size() + 1, reinterpret_cast<const byte*>(data.c_str()), r, id);

          /* ensure that (2, 2) is in that box */
          double qplow[2] = { 2.0, 2.0 };
          double qphigh[2] = { 2.0, 2.0 };
          Region qr = Region(qplow, qphigh, 2);
          MyVisitor q_vis;

          tree->intersectsWithQuery(qr, q_vis);

          return (q_vis.matches.size() == 1) ? 0 : 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lspatialindex", "-o", "test"
    system "./test"
  end
end
