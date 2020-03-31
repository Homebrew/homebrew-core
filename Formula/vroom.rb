class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.6.0.tar.gz"
  sha256 "6bd8736f68c121cd8867f16b654cd36924605ebffea65f1e20fe042e4292175b"

  depends_on "pkg-config" => :build
  depends_on "boost"
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
    assert_equal expected_routes, JSON.parse(output)["routes"]
  end
end
