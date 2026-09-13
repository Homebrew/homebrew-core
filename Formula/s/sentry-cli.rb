class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.6.1.tar.gz"
  sha256 "f5b2a83bfbff443c3235793c4d65e3510a159886951886fab6f582885379e086"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35b7ed2279a3f12bc9a5d2d60e49100954d4733debb6b583bacd84bd3f1d5a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed46a0f0478c238129bc766bb6d5190c687d0e8d23628fdb3d07ed53868a2064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be05940578986bbdb2d59c634cf627a8abf4522b766861466f31f4b5f466766d"
    sha256 cellar: :any_skip_relocation, sonoma:        "45cedd39e9bed6935b7564e3939e09c10c8d82a2191c9351021d6dc9c28606dc"
    sha256 cellar: :any,                 arm64_linux:   "ee54fa16a0ece7e8e6974b1a7bd56852d40d360070417597e45b550deaa26a63"
    sha256 cellar: :any,                 x86_64_linux:  "b1334b1839c555bce3c9e7d2aec01d2d23de9b3d775120211cc1b9982d60b5af"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "swift" => :build, since: :sonoma
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
