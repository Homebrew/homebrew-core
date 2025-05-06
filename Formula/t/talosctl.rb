class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "9c97367ea8635e9cf6610868207c7f103c2f9239a7445fe42001ad3bea5ca237"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa9bf918cbc69277e3bb04a613ddeb78192e145611f9ff6eca08a7fb2ea54049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed6616ed7f0e16dbf476552eda434d18957006b0b41d6a47429b5b849796385"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d078f8db74b7833b06b60d72b3b595259c90f4f6a34790ca6a34abe10f0cd774"
    sha256 cellar: :any_skip_relocation, sonoma:        "ace7fe79146cef2742ba52c99ecf3c5b9b4d7b8ea07b947be911fe1575696c51"
    sha256 cellar: :any_skip_relocation, ventura:       "5dc2169e88aef305c871614c64a1b08e3f5764d141d617daf6ae37d3e51929ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b91e8de125d75d7c5c7c601cafafffc2e4822735c71891cc5a3cdd8af65f778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427d226af06ca564f1ea56039bfa60bbc5291bcc1cd9168c00e39610fa528205"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
