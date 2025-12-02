class Sshportal < Formula
  desc "SSH & Telnet bastion server"
  homepage "https://v1.manfred.life/sshportal/"
  url "https://github.com/moul/sshportal/archive/refs/tags/v1.19.5.tar.gz"
  sha256 "713be8542c93d91811f9643a8a2954ebc15130099e300fedb5ea4785b5337b52"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "abcd2ec2450e2535d5cb8536a5098fc61acdcc34b75c02ce84be5ea958689bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e41e72b749adc2be38fd48aa7bc7414b1e06cefe22e2ee83cd1e62108403d583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d2011f8a00406373f0f08fe0d6ae9bc24319328644de51f42cb67047bf26005"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "924cfb73822486729a932a912d17d4fe202dbe081c8cbc552634c16e9586bb20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf5a4040d0111c3ad348506ef5e454cf106626950e024fd270065bb13e56f96c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4a1076a63578d51bb79f4d6f7c35432771c479d6baf00d2d96556436da6dfd8"
    sha256 cellar: :any_skip_relocation, ventura:        "67da5adbff8a32e081440bb5f2ec8992448dcf7839faa2c8ea236ef596f00f17"
    sha256 cellar: :any_skip_relocation, monterey:       "83612694df61dc4caee75ad516e29c65a1ad024a6008b21188e34bac4d98d985"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dcaa3b282c7d701cc33799bb3d7c754b545d1278367a08421e366e8e330ba374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5184e0795bf5e6e3c1d785919a77d4473c9edbb12bc1e3fc4714c48887b2d178"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.GitSha=#{tap.user}
      -X main.GitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sshportal --version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/sshportal server 2>&1")
    sleep 2
    assert_match "info: system migrated", stdout.readline
  end
end
