class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "123e2c42b20727cf600f449e46f22ebb64cb5d21fa564f42d916ac1406de8b4d"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72258a85094cb54d21bb79925290a83081eea15e1220580f93e734e8576e6906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85c1a22ea0ffadb8e2efb32cba1284c911c98f23d8a1b3c03497d7b86ea9e7bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59df757edf6ae17a7761d80904bf952401cf5ffd2274d5ea5e6ab4e06e1aa2a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4422226a049994752d9d899ae956dd98c3007b9ba2b8e8e8890b65bf8b04d046"
    sha256 cellar: :any_skip_relocation, ventura:       "6cf1fe42fc3dd4c66b4286d7880da361e46f35e27dd2dea42282cc5f6c0bb045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a73601a4d83bfe604ee5ce2f524c4a4f1d49e87477a8b889eda7a898d18aa4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
