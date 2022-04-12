class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.11.0.tar.gz"
  sha256 "ca8c70a0ad3629640bb6c9b5fc5fc732fad36cb8572d0c58ff7e780be15aa544"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "7a823e112cf6cac7b986ca5e142c1517a8be92fc34048ea26ad4cd97e0b68703"
    sha256 cellar: :any, arm64_big_sur:  "3bf10d29ff9e95edd39ac68c2ffde3e87ebb86f42a220486471d3e641b1048e9"
    sha256 cellar: :any, monterey:       "93d5164b0e7630e9af621d7da2eb9c550b23c5701ca28117eb43f16861762377"
    sha256 cellar: :any, big_sur:        "8e22ef70463048645622fa6892cd17561dff683b261e4b0e4133ddded27f6714"
    sha256 cellar: :any, catalina:       "aa67ba7ad30b43826f38d798f67689ad224080791950e82ef763d29420a30e50"
  end

  depends_on "pkg-config" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    chdir "src" do
      system "make"
    end
    bin.install "bin/vroom"
    pkgshare.install "docs"
  end

  test do
    output = shell_output("#{bin}/vroom -i #{pkgshare}/docs/example_2.json")
    expected_routes = JSON.parse((pkgshare/"docs/example_2_sol.json").read)["routes"]
    actual_routes = JSON.parse(output)["routes"]
    assert_equal expected_routes, actual_routes
  end
end
