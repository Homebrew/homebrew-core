class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.8.0.tar.gz"
  sha256 "7f339e1e0ed6c81c02dd78e10d36db5ec09f404b45731b5fc80ed4036634c67a"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "b8b6ba6f23ce63a5d1fe3060c688de42bfd7191ce741bf1f133ad988d2008b8c" => :catalina
    sha256 "598e546078bb441380537ea0fb684d6f20e3a35b8efb8f7561a399e8e4885546" => :mojave
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
