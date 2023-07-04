class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.8.tar.gz"
  sha256 "95206a01fe365a074160189c1718919658834bb5cdd14ab93982201c0d60740b"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a963c9e434f3d4c9bdf163556a042e49e38d7740f123ecbaf0de75b6b47d4057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5449b80fd013dba86476653d33da21971e78a8a2d3697d10f754bf51b62cbac2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee40b2f6a411813ef37e0e501185f7517f82081069a99eca00d7162fb790fb6b"
    sha256 cellar: :any_skip_relocation, ventura:        "bbbfcf5ce77c227365c9652362a44d8f158ada338823b638a6e90c6a06e514c0"
    sha256 cellar: :any_skip_relocation, monterey:       "eaa6700ab0e0c9cb0db3d03dd3a720d7513d4c6f7ed393c39938a5ab40cebef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaef5d204934989dc5084079ba59a6ea8c5f7e0fa16e70cdbf7465a9211ac11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9127fb44d5e6efa1cf6cf98562903203b111696ec017e30fa85806e1c08a44a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
