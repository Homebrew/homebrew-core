class Vouch < Formula
  desc "Project trust management system based on explicit vouches"
  homepage "https://github.com/mitchellh/vouch"
  url "https://github.com/mitchellh/vouch/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "94275ada728b19f0b09e40198003aa047f2cdf75c550ce5413ed87a78c810092"
  license "MIT"
  head "https://github.com/mitchellh/vouch.git", branch: "main"

  depends_on "nushell"

  # https://github.com/mitchellh/vouch/pull/74 remove on next release
  patch do
    url "https://github.com/mitchellh/vouch/commit/5cac3135c47ba91370a36cfc8cedbc0d16eb848f.patch?full_index=1"
    sha256 "98c057dff73302e490aabac156ffde7da3dce7556174308cfa6f0cad74152353"
  end

  def install
    (share/"nushell/lib/vouch").install Dir["vouch/*"]

    inreplace "action/setup-vouch/vouch",
              'vouch_lib_dir="${VOUCH_LIB_DIR:-}"',
              "vouch_lib_dir=\"${VOUCH_LIB_DIR:-#{opt_share}/nushell/lib/vouch}\""
    bin.install "action/setup-vouch/vouch"
  end

  test do
    touch testpath/"VOUCHED.td"
    system bin/"vouch", "add", "foo", "--write"
    system bin/"vouch", "denounce", "bar", "--write"
    vouched = (testpath/"VOUCHED.td").read
    assert_match "foo", vouched
    assert_match "-bar", vouched
  end
end
