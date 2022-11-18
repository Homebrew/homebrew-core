class Spatialindex < Formula
  desc "General framework for developing spatial indices"
  homepage "https://libspatialindex.org/"
  url "https://github.com/libspatialindex/libspatialindex/releases/download/1.9.3/spatialindex-src-1.9.3.tar.bz2"
  sha256 "4a529431cfa80443ab4dcd45a4b25aebbabe1c0ce2fa1665039c80e999dcc50a"
  # `LGPL-2.0` to `MIT` for 1.8.0+ releases
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b70926966d026440d780207a5f7ec0432ce2e5284b62c2907a94393392e6699"
    sha256 cellar: :any,                 arm64_monterey: "1e01a5347e7bc5c45e0f4b06a92265c08868ee384f9e375f0b7cb42a13106fd2"
    sha256 cellar: :any,                 arm64_big_sur:  "5786e51306b202e51c9a81b4bc6c7b593027c8e88b777d142e486bf012eebe34"
    sha256 cellar: :any,                 ventura:        "436732ecbc6b625c4a712c918baf869b9e670bf4a7dea7e18866dce970a9ccfa"
    sha256 cellar: :any,                 monterey:       "2a4b3dfa9dce372c262f91985c7fae864c799ce642725beb237a0a2f6338bad4"
    sha256 cellar: :any,                 big_sur:        "49ef8e79ee6c7348b438d2b174effd66a2a7136a12c58645a0a37a5c22740ce3"
    sha256 cellar: :any,                 catalina:       "fbcbfaf6510137f3168a0dc57cbac8c8b1435094b1ede9d35a30fa6ccaea28f4"
    sha256 cellar: :any,                 mojave:         "a5cbdfb3acddb053e596fc56e7653559581923e48ed6815503fffc47c7a16660"
    sha256 cellar: :any,                 high_sierra:    "cace27981cc1e5143a48e8b700d6823dff9d8049140683e0e536c476894ede91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc7ec6fab28b23661a825c46d29b861fca6a6115048be5f42355da59deed84bb"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
