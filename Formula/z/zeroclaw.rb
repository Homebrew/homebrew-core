class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "25a518774dcabae17961e3729228083ea716e10e6c81db0a3ebdefadceabde36"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5957d401189f7c723f3c97361bed9821c38d19e9993a5393cfbb29245c3cb09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4d7cdd06dfd62765327213c2c8f9156247dd08529736c9c514f20c5ae5ccbbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ff54a7ed37f689538f7a8484fb41770b6682c43eb5dadc3b067f34f361bbd16"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e492d5425b7d1e62caa87df276dee5c99373987227280ab86db39fb1d2c8efe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8deed7f3f096d8ec84a84689205e2cd193e626030c2dc4cc948d47ac89c6177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e63c0dcb759ddfda63c8f901be3f08a43eafe312d10d324030e10215bf2da15"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
