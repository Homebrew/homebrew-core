class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "f39e9b3dfb965197f23481a4f2da64da61ad1b1eba9ee80d0af2792425951521"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "746f8758bebc273b954dfd1ca01ad1c2d0b0f3e5a3fe939f860f0ac30d6f2024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d020bf78f79ed89454f69a26db08c03fdbbfd9d90bf52e9a1e96d3506a2cc57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "993cb55fb76eefd5877521a6cdf95a1f6c966cb5156efc11aba6cc1a0ec4c136"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a2581a21e6bffae6678c4a723dbed5f4da5a0c1d75a7571a75035f5b840d9f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e77fbc1c6e67fec9809481ecf14c09ca662dd3041f7f5d7596f919dafbf1a6ba"
    sha256 cellar: :any_skip_relocation, ventura:        "802d2532eb8d39abc68ab4f9ac44fd2a20ca5cf6753a5db77078b074ce37dc58"
    sha256 cellar: :any_skip_relocation, monterey:       "54f80805658b930252e4cca477361c1af3caccb75cef31a66563982fa8999d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d2cd9b9006096740dd3b7ca7ea36b163a5bd4940565744ac1e9309ff03db15"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
