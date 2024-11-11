class RailsNew < Formula
  desc "Create Rails projects with Ruby installed"
  homepage "https://github.com/rails/rails-new"
  url "https://github.com/rails/rails-new/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d9c11267eb7c7a40a740768d09e5da60e07009d490d6561b734c35ac88095d51"
  license "MIT"
  head "https://github.com/rails/rails-new.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Docker required to actually run rails-new and it creates images.
    # Using a very simple test to verify Rust build is ok
    assert_match("rails-new #{version}", shell_output("#{bin}/rails-new --version"))
  end
end
