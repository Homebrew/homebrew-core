class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "e6c364e3fa5d537fd274e6c87bd249413ad77f3e97fda51eef13e160c5416af4"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1197890b7b8bbccc819cdc36e3a7f8edadbf3449cff85d877d6cdf92d06f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b80f67be1b2f7ec4efcfafa6d4817fd414067769b9cff586038c490820379ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebf4aa5a0e28c64fd6dbd54deab7ef3c68f83f7383e0ab24160a165751b8818f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ab9046d38f66f7ee65a5ec081b04a9d737f1f33274073a30d879236b0015eae"
    sha256 cellar: :any_skip_relocation, ventura:       "70e4cd9c8c70981e6613ad81bf89847cdeca8b740251af8546838581dc013ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d610b03e86d62a64ff04fb164b4a3ee2f796d3d08af7b2ed345e17378326e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      # upstream bug report about creating `.pipes` folder, https://github.com/turbot/steampipe/issues/4402
      assert_match "Error: could not create pipes installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
