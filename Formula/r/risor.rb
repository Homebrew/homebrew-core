class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "016e9917226689560976d1f3c2e16d1af6530c05ae16adc92e71b9740e01057a"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5b08c138141dd652a95ffe417006a326a14cd78b4d45b8702859ec7fa98523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "206ee1737cd952fe7a3333ef80426ba5b0f0299b01760a13b34f692dda76a033"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48b02df886cee81e90bce35431ebcc94bd3e8344b68688af586797eb0d644e1b"
    sha256 cellar: :any_skip_relocation, ventura:        "b1abf5d26b045c2a45e7731a392a9bbc67cbf1b38457aeeede9787faadcbb209"
    sha256 cellar: :any_skip_relocation, monterey:       "e294f7a42aca359c290e28a771b376504213816531bccf9b574030a923e9edfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae15467343a10c8dc7d39bb2a8cba1ebaf81dd43323baaacf1487df0665d3f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "556bf467196ab4cc50c5aab6ed70537476ddfc87ac4e040789a23fbde2ac6086"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
  end
end
