class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.7.0.tar.gz"
  sha256 "17a945170dfa45ae93ac7bbc1f79dba9ccae0f48f40523718c54c0f78c3fd7f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e322024fc998d656c30d3c54ebe8cc55b28599e77273418324022382d252a840"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c238371568bc9d31f23b755d3c245a91e67a471faff13b728d363e0dabe93060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3b05f84efda424728069b98251379ce67de54008707a48e77d50f3051f62f32"
    sha256 cellar: :any_skip_relocation, sonoma:        "93846e4e22491e1f1c16823b368a8bb82ca86834880a3ff2e427fb555e2670bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37bc937d9b7703aee047771abc42bbf984124e0ca714c813301ed093f88962c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f034f976c15d34b8fd7cb31fd31586c11b326b24f14a6de2d6ccae33a73874f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_path_exists testpath/".xwin-cache/splat"
  end
end
