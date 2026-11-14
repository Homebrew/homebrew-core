class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.8.tar.gz"
  sha256 "69b07d633ba2fa8674e2d0d72a7346c17f7a2fdc99d99e0cd86a799b018aaab7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f974e71582d4c314dd47ac96fac3660358570c0e5ed779bf70e3f2fe29e7544"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f974e71582d4c314dd47ac96fac3660358570c0e5ed779bf70e3f2fe29e7544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f974e71582d4c314dd47ac96fac3660358570c0e5ed779bf70e3f2fe29e7544"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e13067b664ada2cf8ab52bf1519474f27a083b097438d5edc5d3b6b28270495"
    sha256 cellar: :any,                 x86_64_linux:      "0e1c0d24a729ebd6e1252c454a81b2b2d7bf84f9cb2c8e42d74ce72fca1ffdc3"
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
