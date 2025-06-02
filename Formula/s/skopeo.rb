class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "043e9f568440accf1aafca122a25c4d21441f16de49475192ec4abeef7430358"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "b92bf9e74a3f729b3ee4022b1b26f4ce9b459d8c1919a438b45ddf61ccee08f9"
    sha256 arm64_sonoma:  "e4d4585fec2cd666321ed3a3c4ac086a454589614280391bbc5ab52eb0331cba"
    sha256 arm64_ventura: "7e2b25e6d2f2a2649eae99ed1e9313e55b0ec8b4a386189844dab63e8f27c496"
    sha256 sonoma:        "56921c1ded643f7a11ffb8b1ade837cf89d5f95ff695343a275186c31cc48733"
    sha256 ventura:       "bea60e3be5267fcf0aad619f9bb5d833e6eb25374b4b2a3e5aa3453911b04e55"
    sha256 x86_64_linux:  "46546e227bc13941c5a6a980ba444703cf1df6efffc989636e39677b33874fe1"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin/"gpgme-config", "--cflags")

    tags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libsubid_tag.sh").chomp,
    ].uniq

    ldflag_prefix = "github.com/containers/image/v5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_prefix}/signature.systemDefaultPolicyPath=#{etc}/containers/policy.json
      -X #{ldflag_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", "completion")
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match(/Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1))
  end
end
