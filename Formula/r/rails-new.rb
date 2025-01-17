class RailsNew < Formula
  desc "Create Rails projects with Ruby installed"
  homepage "https://github.com/rails/rails-new"
  url "https://github.com/rails/rails-new/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9a309ea0d3f7b7c10327aba30e919bab30efc3bdffc2fcedaa54ce23d9e4ae42"
  license "MIT"
  head "https://github.com/rails/rails-new.git", branch: "main"

  depends_on "rust" => :build
  depends_on "docker" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/rails-new --version")

    output = shell_output("#{bin}/rails-new testapp 2>&1", 101)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
