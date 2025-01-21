class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "916d4a990f9ca5844a36ac8e090797cd26c8c1c8eddf5a7aa659e2538a865151"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "478d6dc0dfe21dfad327c0a3990620c50c9be18b6838afc4bd5b7899312fd199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "478d6dc0dfe21dfad327c0a3990620c50c9be18b6838afc4bd5b7899312fd199"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "478d6dc0dfe21dfad327c0a3990620c50c9be18b6838afc4bd5b7899312fd199"
    sha256 cellar: :any_skip_relocation, sonoma:        "7df04541ed2601987a9db28b38acf311953c1b7ae2893ada42aadf1408c39200"
    sha256 cellar: :any_skip_relocation, ventura:       "7df04541ed2601987a9db28b38acf311953c1b7ae2893ada42aadf1408c39200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03afc26880e54b17a695e95a5c0b036ef80a37bfa2c2aac4e8ea014bac82dfaf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
