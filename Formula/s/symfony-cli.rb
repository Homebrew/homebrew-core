class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.19.0.tar.gz"
  sha256 "09fb1ab64422b9f8388d303fc513d27a773a4a807c10d55b9f8c35300551bd2f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f027e096d3efa44395284209c963820add9f6423db30154fa5e92cf7991b59f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42802acfb3bdb2d8bb47e5d59beb0857c826cbc88434218eaa5012a75eef8c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ac18ebab87bc8b909399f84c9780c94b526a88cc300e991d4ee34a8acb02cce"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1a6b1436130dc8810d018e4262aa70f1a56a9dcd1d9019ee1106cf4388e344c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d674394ea8a904a687c163d2407b45350da0a755b5864b0e87e2838802cc0729"
    sha256 cellar: :any,                 x86_64_linux:  "9e41e332c4be31bc85f6f752d34bc4784b4dfce4e8eb5f2a6840007cd7651563"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end
