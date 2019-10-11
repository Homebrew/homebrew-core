class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.org/"
  url "https://github.com/libspatialindex/libspatialindex/releases/download/1.9.0/spatialindex-src-1.9.0.tar.gz"
  sha256 "52d6875deea12f88e6918d192cbfd38d6e78d13f84e1fd10cca66132fa063941"

  bottle do
    cellar :any
    sha256 "8160971381ca1e80b0df398a5c8a18c0d49cd8722bf8ae13bc3d08a49e427d2a" => :catalina
    sha256 "bdda20e0607a6ac0a2bbf3ee37c0d507b7f9ede93f2210c3b33887b1682c173e" => :mojave
    sha256 "81cb9da70510a276cf06cc993f1b94aa27ce688b923aeac8170df372496bd371" => :high_sierra
    sha256 "98434cec34dcc25434dd5ea1ea669b4f4471f1b361f17dbe408c1e984eb6016f" => :sierra
  end

  def install
    ENV.cxx11

    ENV.append "CXXFLAGS", "-std=c++11"

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lspatialindex", "-o", "test"
    system "./test"
  end
end
