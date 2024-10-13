class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ff89dba4d40109ffc87d4201f46ec1e9b8dcc02242e32ffc94a5379241b56ef8"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f1d1ec17d501b7882fd7d854da0d6f314626709be2729d1aeac7f61aa5746c08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7deb17cb2b97a8fa6c260b39e0c99a78aefc0ce74e823c3755f4f473d2fc34e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7deb17cb2b97a8fa6c260b39e0c99a78aefc0ce74e823c3755f4f473d2fc34e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7deb17cb2b97a8fa6c260b39e0c99a78aefc0ce74e823c3755f4f473d2fc34e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "10a5ce042e1310f02092eaeebc3a1938fa168c27104c85989b1ed732de4d5c0c"
    sha256 cellar: :any_skip_relocation, ventura:        "10a5ce042e1310f02092eaeebc3a1938fa168c27104c85989b1ed732de4d5c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "10a5ce042e1310f02092eaeebc3a1938fa168c27104c85989b1ed732de4d5c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d539b877d0b3ed12eed5ebafc770308ab82c20c45b0b9a144adfb58872be812c"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    (man1/"vhs.1").write Utils.safe_popen_read(bin/"vhs", "man")

    generate_completions_from_executable(bin/"vhs", "completion")
  end

  test do
    (testpath/"test.tape").write <<-TAPE
    Output test.gif
    Type "Foo Bar"
    Enter
    Sleep 1s
    TAPE

    system bin/"vhs", "validate", "test.tape"

    assert_match version.to_s, shell_output("#{bin}/vhs --version")
  end
end
