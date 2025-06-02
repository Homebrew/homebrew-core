class Todoist < Formula
  desc "CLI for Todoist"
  homepage "https://github.com/sachaos/todoist"
  url "https://github.com/sachaos/todoist/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b8220ec1ec14f298afed0e32e4028067b8833553a6976f99d7ee35b7a75d5a71"
  license "MIT"
  head "https://github.com/sachaos/todoist.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a545ff334ff243fa80136cd50d3dd67d4dec54469e02550f359d60686dcbb3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a545ff334ff243fa80136cd50d3dd67d4dec54469e02550f359d60686dcbb3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a545ff334ff243fa80136cd50d3dd67d4dec54469e02550f359d60686dcbb3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e226a4397f68b89ef40017e4c78cf9480eb4157c6525bbef69e66269bb3dacfc"
    sha256 cellar: :any_skip_relocation, ventura:       "e226a4397f68b89ef40017e4c78cf9480eb4157c6525bbef69e66269bb3dacfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e390f5c218ded4bb493af4beff7bc48203cc3cac2d541225b685fe3929b3ce5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/todoist --version")

    test_config = testpath/".config/todoist/config.json"
    test_config.write <<~JSON
      {
        "token": "test_token"
      }
    JSON
    chmod 0600, test_config

    output = shell_output("#{bin}/todoist list 2>&1")
    assert_match "There is no task.", output
  end
end
