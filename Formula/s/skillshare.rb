class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "3267a881a3cf15dc7052d446ec305daaac74f75136791e050ab37241613531d9"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45008ebf28de700a55abb4ccc7c8389fffe94329a2d15330ff721ea297a0891e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45008ebf28de700a55abb4ccc7c8389fffe94329a2d15330ff721ea297a0891e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45008ebf28de700a55abb4ccc7c8389fffe94329a2d15330ff721ea297a0891e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f2be05ff3f627fa03c440aba77962db3c335df5bd0c9a7cb1d7c1a943ba5ca79"
    sha256 cellar: :any,                 x86_64_linux:      "4f124b866a2beecef1c61fea26288396adb10162348fd9662b27ecfada6306ed"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
