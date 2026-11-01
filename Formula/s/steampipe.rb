class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.9.tar.gz"
  sha256 "890d0bed4fd7df7ff11c632f9eb1744f8abe2fa202302c8942b76b89b27579c9"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e67758f700ff23a9b70bbe8ea3f068e2ba5b71603ce653f76eb4f7070179cf90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "027247d2ee6b6955cb650fad51b8cc68f00da0f3dec8e781f129d0cc04d7d056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43adba54222d7997105914738caf3788b31fd1647e612feb6511af61332c911c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60d9c581bb5528ac710d4f840411991e40a347da9b461ec45fc08f4f83046562"
    sha256 cellar: :any,                 x86_64_linux:      "8dc76de3ba06beb514501f809ed81c3fefb552adcc50d390d2f77ed7330a8680"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "http2legacy")

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match version.to_s, shell_output("#{bin}/steampipe --version")
  end
end
