class Virtiofsd < Formula
  desc "Vhost-user virtio-fs device backend written in Rust"
  homepage "https://gitlab.com/virtio-fs/virtiofsd"
  url "https://gitlab.com/virtio-fs/virtiofsd/-/archive/v1.15.0/virtiofsd-v1.15.0.tar.bz2"
  sha256 "514ff9e425a4f6f7c7218107a9535e389a9d56881c4f01e77f4e4880e4a342d8"
  license all_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://gitlab.com/virtio-fs/virtiofsd.git", branch: "main"

  bottle do
    manifest_sha256 "ab59268f9fe38e6128ee8c8c3e617dae98444eb2cc058156d1e526006b5006a5"
    sha256 cellar: :any, arm64_linux:  "5234dc848f77555c4fed0b8ca3b15804a0050cc38ba7619f442b7c8ca7abd348"
    sha256 cellar: :any, x86_64_linux: "6ff40d1e12a7926fa221e64926a88eb66424a3d88938a039608776de7400ff12"
  end

  depends_on "rust" => :build
  depends_on "libcap-ng"
  depends_on "libseccomp"
  depends_on :linux

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "socket"

    assert_match version.to_s, shell_output("#{bin}/virtiofsd --version")

    sock = testpath/"virtiofsd.sock"
    shared = testpath/"shared"
    shared.mkpath

    with_test_process(bin/"virtiofsd", "--shared-dir", shared, "--socket-path", sock,
                      "--sandbox", "none", "--log-level", "off") do
      sleep 2
      assert_predicate sock, :socket?
    end
  end
end
