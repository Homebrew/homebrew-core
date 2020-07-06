class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.6.0.tar.gz"
  sha256 "6bd8736f68c121cd8867f16b654cd36924605ebffea65f1e20fe042e4292175b"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "d456cedbd8a14b0bf4a522c1e982761487b8b93baa8db7198875c48ac84bca68" => :catalina
    sha256 "678a00e9b7f1971bd55832bff3a73503e40d453a2c39e6c7499256ca7638937d" => :mojave
    sha256 "aa74496ac296cf599254f6869e13ec0fc6ffb72d1d6e787f0ed302754bfcd44e" => :high_sierra
  end

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
