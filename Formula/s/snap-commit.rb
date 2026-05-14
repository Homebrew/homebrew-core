class SnapCommit < Formula
  desc "Lightweight CLI tool for Conventional Commits"
  homepage "https://github.com/nxkh4ng/snap-commit"
  url "https://github.com/nxkh4ng/snap-commit/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d29fad7a42cfd471498500c1b82dbea75c73867a6719365dd3e79bf50b8df56a"
  license "MIT"

  depends_on "go" => :build

  def install
    # Binary named "snap" for shorter CLI; formula named "snap-commit" to avoid
    # namespace conflict with Canonical's snap package
    ldflags = "-s -w -X github.com/nxkh4ng/snap/cmd.version=#{version}"
    system "go", "build", "-o", bin/"snap", "-ldflags=#{ldflags}"
  end

  test do
    assert_match "snap version #{version}", shell_output("#{bin}/snap --version")
  end
end
