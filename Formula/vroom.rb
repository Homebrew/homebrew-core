class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.8.0.tar.gz"
  sha256 "7f339e1e0ed6c81c02dd78e10d36db5ec09f404b45731b5fc80ed4036634c67a"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "afa201989a1bd34ddf8dc96379bffe303eaa855a05dbbae570f44974bf5bf7e6" => :catalina
    sha256 "9ac415735021d7f3dd94247d0c9a8c7cfe2f4b1d1ec0ea1950663db92d70ff19" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@1.1"

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
