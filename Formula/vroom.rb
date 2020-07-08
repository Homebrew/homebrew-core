class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.7.0.tar.gz"
  sha256 "38231586070a46c95328c4e8d48dd0b84acd02dd9904f988cbb53ce51c4e62e4"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "d456cedbd8a14b0bf4a522c1e982761487b8b93baa8db7198875c48ac84bca68" => :catalina
    sha256 "678a00e9b7f1971bd55832bff3a73503e40d453a2c39e6c7499256ca7638937d" => :mojave
    sha256 "aa74496ac296cf599254f6869e13ec0fc6ffb72d1d6e787f0ed302754bfcd44e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "asio"
  depends_on :macos => :mojave # std::optional C++17 support
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
    actual_routes.first["steps"].each { |r| r.delete("id") } # temp fix, remove in next version
    assert_equal expected_routes, actual_routes
  end
end
