class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "c56154a3c31b23751a02d3301064ba75e112f39d36473fb467f4c50d89b3d548"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba28683a72f105cf01881e880a84e2eba88621b1b0d783ca09bbaa5e60cd282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba28683a72f105cf01881e880a84e2eba88621b1b0d783ca09bbaa5e60cd282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba28683a72f105cf01881e880a84e2eba88621b1b0d783ca09bbaa5e60cd282"
    sha256 cellar: :any_skip_relocation, sonoma:        "58eec407bb1e20b050d713a28f078fea26dda41df7711b108ab56fa7531407d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262b873001d7da9f951d69b5c9ce1211653501e22c87f8ddfc6b7972bfc64eb0"
    sha256 cellar: :any,                 x86_64_linux:  "98224bc4b6211955d564fc749744c5fec445134e640ad86cf7bb9bdd9df80144"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
