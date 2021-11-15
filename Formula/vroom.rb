class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom/archive/v1.10.0.tar.gz"
  sha256 "6426c32133b9ef7a41f88cf4b506848c34feca74fd3fc9b5bf2bcd96a2f436f1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "b752eee30dd3872d44a702f903ac8a4bc0d37a1187a4f54f038f86508409912d"
    sha256 cellar: :any, arm64_big_sur:  "76c2218be30b352eb31c178ab9c25930b0fd80bc1d603defbf1d2ebf92e1875e"
    sha256 cellar: :any, monterey:       "7ff7b7dfed08fae712ca628f7c2948a5006b9371c199a750ddfeda6109757fd6"
    sha256 cellar: :any, big_sur:        "59ca347b0dd9ba423ca9006997a8051c0d9e5c98c7d3876302575aa77073dff7"
    sha256 cellar: :any, catalina:       "637d2de102155f8cf96c3ff168c0503cb3cc0ae8abddcc33ed3fe869213613d0"
    sha256 cellar: :any, mojave:         "c283fdbd2e5f26ed93fbf56e8aa8501381fdfa3918f4271cd87301a4e890d801"
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
