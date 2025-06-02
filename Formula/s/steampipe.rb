class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "082810c9083f6224e7bff850b366c8889be8aac434cec255504fbad3f3dae5cd"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2b32954ce511047081e519ca811cb038e1484f2c493b4ace2775b35501c548a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a40cab4ce04ee834fc8f1bf7ed89061fe8aa256ca64adee5ab6c063184b078c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cf35a25f625f3b0b1e61f0c8e536ee4cb98107b350f2dfdd41e6b8fc452fb96"
    sha256 cellar: :any_skip_relocation, sonoma:        "102ecd50a9676fae20173e7cbfa980e1dd0401a896a011d165e61bb1cb95b931"
    sha256 cellar: :any_skip_relocation, ventura:       "a984e904530c54c171a62a0866750def5fe647162351b20fbe90e78274256bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98f015a2014748b10e7aed291ace764aef7494e3492498d606a60d3f8ffb13c"
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
