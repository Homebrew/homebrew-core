class RmImproved < Formula
  desc "Command-line deletion tool focused on safety, ergonomics, and performance"
  homepage "https://github.com/nivekuil/rip"
  url "https://static.crates.io/crates/rm-improved/rm-improved-0.13.1.crate"
  sha256 "6964bbdb1633b3af61aa3488175d111bb5cc84e56cd668255e0fb7dce4008722"
  license "GPL-3.0-or-later"
  head "https://github.com/nivekuil/rip.git", branch: "master"

  bottle do
    rebuild 2
    manifest_sha256 "1a7603c94a71bd12065b665f9c9ba5efd44209cf871be22aea1b62706c10cfcf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "660e12ba9009e18e8a0bfd2be915afb5ba712523fe14461f26556889a5f09dc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e73f26e21be0940c1377902b1c9c4497cc372327d56478b4cc54e3520be44b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d100fb8045d0e637caf2931dc7c6acf352d8ebfdebbd2bc879c7668885f9b879"
    sha256 cellar: :any,                 arm64_linux:       "e4016ae8654dd0ecae41b76a12a0b52c24b22d13a1e6b0b7e2b8d91cb6720b54"
    sha256 cellar: :any,                 x86_64_linux:      "cfd9efdfdfce21846028dd84435094a50dffb5a6411751a79c20e1f6d3e88985"
  end

  depends_on "rust" => :build

  conflicts_with "rip2", because: "both install `rip` binaries"

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    trash = testpath/"trash"
    ENV["GRAVEYARD"] = trash

    source_file = testpath/"testfile"
    deleted_file = Pathname.new File.join(trash, source_file)
    touch source_file

    system bin/"rip", source_file
    assert_match deleted_file.to_s, shell_output("#{bin}/rip -s")
    assert_path_exists deleted_file

    system bin/"rip", "-u", deleted_file
    assert_path_exists source_file
  end
end
