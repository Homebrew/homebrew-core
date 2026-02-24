class Vouch < Formula
  desc "Project trust management system based on explicit vouches"
  homepage "https://github.com/mitchellh/vouch"
  url "https://github.com/mitchellh/vouch/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "94275ada728b19f0b09e40198003aa047f2cdf75c550ce5413ed87a78c810092"
  license "MIT"
  head "https://github.com/mitchellh/vouch.git", branch: "main"

  depends_on "nushell"

  def install
    (share/"nushell/lib/vouch").install Dir["vouch/*"]

    # Wrapper script based on upstream's setup-vouch action:
    # https://github.com/mitchellh/vouch/blob/c6d80ead49839655b61b422700b7a3bc9d0804a9/action/setup-vouch/action.yml
    (buildpath/"vouch-wrapper").write <<~BASH
      #!/usr/bin/env bash
      cmd=''
      for a in "$@"; do cmd="$cmd $(printf '%q' "$a")"; done
      if [ $# -eq 0 ]; then cmd='vouch main'; fi
      exec nu --no-config-file -c "use '#{opt_share}/nushell/lib/vouch' *; $cmd"
    BASH
    bin.install "vouch-wrapper" => "vouch"
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
