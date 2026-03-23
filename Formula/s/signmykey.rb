class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io/"
  url "https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "106a3a3d07aa2841d280ab378ce382a2bfca10101080936e2b02c4cc4e7d7392"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90a3fa84385d0929c68ee02274431316e4084865eb5ad9dbb7cb060be7a7b354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90a3fa84385d0929c68ee02274431316e4084865eb5ad9dbb7cb060be7a7b354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a3fa84385d0929c68ee02274431316e4084865eb5ad9dbb7cb060be7a7b354"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ea74b2812543ca3d79a381359f2412bed177bd86cc3208dd4afad608781fb82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fabc7ade5f371c73f57886c343c2aba945fe667eb0b2ee8c6cd21522e4a1fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5234e51f91e4299f1792be2cab5ec37bd1c669830851af5488dba303537edf6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/signmykeyio/signmykey/cmd.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"signmykey", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/signmykey version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/signmykey server dev -u myremoteuser")
    sleep 2
    assert_match "Starting signmykey server in DEV mode", stdout.readline
  end
end
