class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "702da1d2dd2dd60c7cab50a54a63a9ec274a62514c74b29914472a96c046128e"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dda30e11ef7880f60fb304a39349f2a5423301d2667ef6de958725e958f3958c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c103c9963c96cab893236cf8f71035058b5dd92107a85d5181b47b41082efc7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91c1b95ea88ba3890bd0fa9d5ed3a78fae15dac3becacc705a444617b5bcdd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a6f7c1c482d90418e0f05be4b96ec3d7af23fcb45ad1c5ee6a18aac806e155d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cbbc7ac6028ad0ecf9fac23fc3b95922bd6703e8e1a4bfb99f197d1b51e79e9"
    sha256 cellar: :any_skip_relocation, ventura:       "47efbcac6610f710025dc4c6879dea33d3a3d56a42afced74b0b957bbafcd4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5065697fb1a08ea98d09f5f9df4c5855843001e9ecfe82a2e24a47f86e6ed292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f10ae153cf697058df7576644d2f7e43268b86c510c789dd562f953a7dc3202"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
