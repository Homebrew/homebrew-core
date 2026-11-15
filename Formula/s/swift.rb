class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/swiftlang/swift/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
  sha256 "c9c0c37995aa69994807eeb62c1e7e89bdd9f1a366dd8fc98a4bf65753dc6cbb"
  license "Apache-2.0"
  compatibility_version 1

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(/swift[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "630d5bd2629798611a072b7c03c96b069e9b8f30032dd93f687a59d13e8593da"
    sha256 arm64_tahoe:       "c2574f0b7e42f3435db27211295f7d61e38db89e14f3663048225a40ce102094"
    sha256 arm64_sequoia:     "3abad2e45d00a511ecb0a496b0494460cd2a9ee9afbb0b453b43f88ef1539022"
    sha256 arm64_linux:       "166ebbf733b64299c1a9336853e8f851d329260c88012d3dce536e1df1ab820b"
    sha256 x86_64_linux:      "89e667d11552b2874e5374897dcc609b9040804359104421a8650e07de62d6cf"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "python@3.15"
  depends_on "zstd"

  uses_from_macos "llvm" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  on_macos do
    # As a starting point, check `minimum_version` in `validate_xcode_compatibility`:
    # https://github.com/swiftlang/swift/tree/swift-#{version}-RELEASE/utils/build-script
    # This is community-sourced so may not be accurate. If the version in this formula
    # is higher then that is likely why.
    depends_on xcode: ["14.3", :build]
  end

  on_linux do
    depends_on "lld" => :build
    depends_on "util-linux"
    depends_on "zlib-ng-compat"

    # Doesn't have to be in sync but does need to be no older than X.(Y - 1).0
    resource "bootstrap" do
      on_arm do
        url "https://download.swift.org/swift-6.3.3-release/ubuntu2404-aarch64/swift-6.3.3-RELEASE/swift-6.3.3-RELEASE-ubuntu24.04-aarch64.tar.gz"
        sha256 "47126395429653fa768d370655876ec1b68f6a95c7884f5e4f179700141c9b7f"
      end
      on_intel do
        url "https://download.swift.org/swift-6.3.3-release/ubuntu2404/swift-6.3.3-RELEASE/swift-6.3.3-RELEASE-ubuntu24.04.tar.gz"
        sha256 "da8272a5fddccd65b1529ed0e52e04526e2eadd4237d58d6220efeb973c6cd19"
      end
    end

    resource "swift-corelibs-foundation" do
      url "https://github.com/swiftlang/swift-corelibs-foundation/archive/refs/tags/swift-6.4.0-RELEASE.tar.gz"
      sha256 "4d54f115ca4f24f77117c97e64760f6379bb45745a5c79d52a2877fe84c6ad5c"

      livecheck do
        formula :parent
      end
    end

    resource "swift-foundation" do
      url "https://github.com/swiftlang/swift-foundation/archive/refs/tags/swift-6.4.0-RELEASE.tar.gz"
      sha256 "cd7b137cb279425ee494e61a3552b361fd4e764031fc9ae75cc8c5876b8eec3e"

      livecheck do
        formula :parent
      end
    end

    resource "swift-foundation-icu" do
      url "https://github.com/swiftlang/swift-foundation-icu/archive/refs/tags/swift-6.4.0-RELEASE.tar.gz"
      sha256 "1bc3f6f49783da52b7d6d65e08f9b3a0ba3063c341176a9139c2cea9c9c348f0"

      livecheck do
        formula :parent
      end
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/swiftlang/swift-corelibs-libdispatch/archive/refs/tags/swift-6.4.0-RELEASE.tar.gz"
      sha256 "af15fcc3da4514def6454ed672b82daa9ac1d40cb1d08fb69a6611cb8fc104c6"

      livecheck do
        formula :parent
      end
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/swiftlang/swift-corelibs-xctest/archive/refs/tags/swift-6.4.0-RELEASE.tar.gz"
      sha256 "c7fc1058e766270155652311794a660f4b62ca9f8db125d2222e2a8695d9975a"

      livecheck do
        formula :parent
      end
    end
  end

  # Swift adds RPATHs so we can keep `@rpath` install names. This also avoids
  # needing to patch in `-headerpad_max_install_names` for swift-built dylibs
  preserve_rpath

  fails_with :gcc do
    cause "Currently requires Clang to build successfully."
  end

  resource "llvm-project" do
    url "https://github.com/swiftlang/llvm-project/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "f551dffa43b2a7150c35b31fd7d0b823400b029f28c0b5339ee0f88f2684f7ed"

    livecheck do
      formula :parent
    end
  end

  resource "cmark" do
    url "https://github.com/swiftlang/swift-cmark/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "e9fb077781f4511103d5e404b7760ee07b688dc95e32f52616883c10ae3e669a"

    livecheck do
      formula :parent
    end
  end

  resource "llbuild" do
    url "https://github.com/swiftlang/swift-llbuild/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "74350fec385b7b88a2f225fc7029752afc2b32f3f7953481dc8aa16299afa128"

    livecheck do
      formula :parent
    end

    # Fix build when curses can't be found in the default linker path
    patch do
      url "https://github.com/Bo98/swift-llbuild/commit/61810b86c1c59283edbf1cf7a27f538e1d060537.patch?full_index=1"
      sha256 "e55fe1b2d1e1edd196e2a1a4183454739cfdb4a41cae67ac3cbce6ee15117323"
      type :unofficial
    end

    # Workaround Homebrew sqlite3 not being found.
    patch do
      file "Patches/swift/llbuild-sqlite3.patch"
      type :unofficial
      resolves "https://github.com/swiftlang/swift-llbuild/issues/901"
    end
  end

  resource "swift-build" do
    url "https://github.com/swiftlang/swift-build/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "065d1619da577ce0a7b4c5e2d08b7da8100d4c80b8f75d42c6ed92081330d656"

    livecheck do
      formula :parent
    end

    # Backport fix for linking static libs
    patch do
      url "https://github.com/swiftlang/swift-build/commit/9766f5f94a3b1e384995ecfe44681240080258c7.patch?full_index=1"
      sha256 "c499e470c9d4909ebccb6f580a468e0237c4769773620825581019db13a2d24b"
      type :backport
      resolves "https://github.com/swiftlang/swift-build/issues/1764"
    end
  end

  resource "swiftpm" do
    url "https://github.com/swiftlang/swift-package-manager/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "504e72d3e5c8eed8bb47fb5f997f2390066ed52cb8467b18bcd664951c6bc08b"

    livecheck do
      formula :parent
    end

    # Fix for lld to find -lsqlite3 when auto-linking is done via CMake
    patch do
      file "Patches/swift/swiftpm-sqlite3.patch"
      type :unofficial
    end
  end

  resource "indexstore-db" do
    url "https://github.com/swiftlang/indexstore-db/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "51e5cdae88b8fc3e359e329358869f1d26348fa0f132f9e997c8736f671833b7"

    livecheck do
      formula :parent
    end
  end

  resource "sourcekit-lsp" do
    url "https://github.com/swiftlang/sourcekit-lsp/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "2efa362852b055c6653629cf542182daa181c59928e3efbdb0b15923a738326f"

    livecheck do
      formula :parent
    end
  end

  resource "swift-driver" do
    url "https://github.com/swiftlang/swift-driver/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "7511962f6f0aad7a288f1a3130e8edb5d98ff905545897d71edfe0d287aabf93"

    livecheck do
      formula :parent
    end
  end

  resource "swift-tools-support-core" do
    url "https://github.com/swiftlang/swift-tools-support-core/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "e4157ca16a5a5b31788c7455a8dddc5b2ed1b747fd523acedba2dd4f735465bf"

    livecheck do
      formula :parent
    end

    # Fix "close error" when compiling SwiftPM.
    patch do
      url "https://github.com/Bo98/swift-tools-support-core/commit/dca5ee70e302df065178cc8a75a2d6ea00886c40.patch?full_index=1"
      sha256 "e5e2e7cec7b7bd9ef0def5cfc9b1308fe1f25f6228973031c9821b2c4475c8a1"
      type :unofficial
      resolves "https://github.com/swiftlang/swift-tools-support-core/pull/456"
    end
  end

  resource "swift-docc" do
    url "https://github.com/swiftlang/swift-docc/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "2261069272e00ea26f21c980eed159a35507898f9ecfb5286a5a4672d4ad8189"

    livecheck do
      formula :parent
    end
  end

  resource "swift-lmdb" do
    url "https://github.com/swiftlang/swift-lmdb/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "504c2b22bb9a8c43d9c0b511dfdc4cb828bf41a5abcbca26795c7d79d5ff2eb7"

    livecheck do
      formula :parent
    end
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/swiftlang/swift-docc-render-artifact/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "99ab4f91d77f4a4bf84a2e2f457356e6bd7d02bb96fa44e159a1811eb8d13d2b"

    livecheck do
      formula :parent
    end
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/swiftlang/swift-docc-symbolkit/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "c79e819ee831a8741a7821c8e9f05f4e49253ebc413cc3e636d7d642c1e858c3"

    livecheck do
      formula :parent
    end
  end

  resource "swift-markdown" do
    url "https://github.com/swiftlang/swift-markdown/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "ce898c31ea30e3b0bbfb8bb19d1b587d68a2852a1e4033172ed7a4aaa2156cf3"

    livecheck do
      formula :parent
    end
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/swiftlang/swift-experimental-string-processing/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "8452bfdeac7f1afb9fe91faeba34f09ad46eb8e3085d345d3839f9ad4b69032b"

    livecheck do
      formula :parent
    end
  end

  resource "swift-syntax" do
    url "https://github.com/swiftlang/swift-syntax/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "490f1f3da78a4d98a786c2edfef764aa5011db08c0ff737e78f0ec7186c038a6"

    livecheck do
      formula :parent
    end
  end

  resource "swift-testing" do
    url "https://github.com/swiftlang/swift-testing/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "4753bbc1600acee5c54b71c4006ebc082c8a38ac8223dd6b1d7585dad97536e4"

    livecheck do
      formula :parent
    end
  end

  resource "swift-tools-protocols" do
    url "https://github.com/swiftlang/swift-tools-protocols/archive/refs/tags/swift-6.4.2-RELEASE.tar.gz"
    sha256 "48e48cb2f4f76f50587555d2e9b14257ee6ed9263193e8a6359e3f4d5651bf80"

    livecheck do
      formula :parent
    end
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/swiftlang/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.6.1.tar.gz"
    sha256 "d2fbb15886115bb2d9bfb63d4c1ddd4080cbb4bfef2651335c5d3b9dd5f3c8ba"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-argument-parser")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https://github.com/apple/swift-atomics/archive/refs/tags/1.2.0.tar.gz"
    sha256 "33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-atomics")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https://github.com/apple/swift-collections/archive/refs/tags/1.1.6.tar.gz"
    sha256 "2f558b33b6eba5b0c263110d7cb1a11b59d63059e845dc1984c65359e36f29da"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-collections")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https://github.com/apple/swift-crypto/archive/refs/tags/3.12.5.tar.gz"
    sha256 "cad9b04e5e23706bc3bf00ba6a976c397fea8111d964656a1a459fa4b1dc36a3"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-crypto")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-certificates" do
    url "https://github.com/apple/swift-certificates/archive/refs/tags/1.10.1.tar.gz"
    sha256 "1002a2aa66ced92dd216b9ed236d9ce8c73f98f02810f39f2437d43ba35d60a0"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-certificates")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-asn1" do
    url "https://github.com/apple/swift-asn1/archive/refs/tags/1.3.2.tar.gz"
    sha256 "45061bdf808ed138a71b55abc90c8cbff8980b82e5ffd39d86e65a5cbee31241"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-asn1")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-numerics" do
    url "https://github.com/apple/swift-numerics/archive/refs/tags/1.0.2.tar.gz"
    sha256 "786291c6ff2a83567928d3d8f964c43ff59bdde215f9dedd0e9ed49eb5184e59"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-numerics")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-system" do
    url "https://github.com/apple/swift-system/archive/refs/tags/1.5.0.tar.gz"
    sha256 "4bf5d5db04d48f484289371b63dd7bdced0db1ab1307c49127b9f894341a521d"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-system")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio" do
    url "https://github.com/apple/swift-nio/archive/refs/tags/2.92.2.tar.gz"
    sha256 "d4b7d348e160044ddd395b4f0614eb92f25bf14ddc56d7e3a87816b283edab91"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-nio")&.scan(regex)&.[](0)
      end
    end
  end

  # As above: refer to update-checkout-config.json
  resource "swift-toolchain-sqlite" do
    url "https://github.com/swiftlang/swift-toolchain-sqlite/archive/refs/tags/1.0.9.tar.gz"
    sha256 "dd2879b21ca9f2ceeadcd25881d3e1845f3db865026e2e7e7a2b1dfd62c637ec"

    livecheck do
      url "https://raw.githubusercontent.com/swiftlang/swift/refs/tags/swift-#{LATEST_VERSION}-RELEASE/utils/update_checkout/update-checkout-config.json"
      regex(%r{^(:?release/)?(\d+(?:\.\d+)+)$}i)
      strategy :json do |json, regex|
        # `LATEST_VERSION` constant does not work here as the substitution happens only in `url`
        # Selecting the latest version in `update-checkout-config.json` and assume it's the same as `LATEST_VERSION`
        latest_version = json["branch-schemes"].keys.max_by do |key|
          # Use `|| Version.new("0")` to prevent `nil` comparison exception
          key.match(%r{^release/(\d+(?:\.\d+)+)$}i) { |m| Version.new(m[1]) } || Version.new("0")
        end
        json.dig("branch-schemes", latest_version, "repos", "swift-toolchain-sqlite")&.scan(regex)&.[](0)
      end
    end
  end

  # Homebrew-specific patch to make the default resource directory use opt rather than Cellar.
  # This fixes output binaries from `swiftc` having a runpath pointing to the Cellar.
  # This should only be removed if an alternative solution is implemented.
  patch do
    file "Patches/swift/homebrew-resource-dir.diff"
    type :unofficial
  end

  # Fix linkage test failure on Linux for missing libswiftCore.so as RPATH was not updated for
  # https://github.com/swiftlang/swift/commit/7f67eb3fc57b95c023f4c7d767a0f241e0ee541a
  # Skip module-only architectures (custom targets) when adding backtracing assembly sources
  patch :DATA

  deny_network_access!

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    install_prefix = if OS.mac?
      toolchain_prefix = "/Swift-#{version.major_minor}.xctoolchain"
      "#{toolchain_prefix}/usr"
    else
      # Swift Build expects a `<toolchain>/usr/bin/swiftc` layout
      "/libexec/usr"
    end

    ln_sf buildpath, workspace/"swift"
    resources.each { |r| r.stage(workspace/r.name) }

    # Disable invoking SwiftPM in a sandbox while building some projects.
    # This conflicts with Homebrew's sandbox.
    helpers_using_swiftpm = [
      workspace/"indexstore-db/Utilities/build-script-helper.py",
      workspace/"sourcekit-lsp/Utilities/build-script-helper.py",
      workspace/"swift-docc/build-script-helper.py",
    ]
    inreplace helpers_using_swiftpm, /swiftpm_args(: List\[str\])? = \[/, "\\0'--disable-sandbox',"
    inreplace workspace/"swift-docc/build-script-helper.py",
              "[swift_exec, 'package',",
              "\\0 '--disable-sandbox',"
    # `swift-bootstrap` builds SwiftPM with Swift Build, which sandboxes macro plugins unconditionally
    inreplace workspace/"swiftpm/Sources/swift-bootstrap/main.swift",
              "shouldDisableSandbox: false,", "shouldDisableSandbox: true,"

    # Fix swift-driver somehow bypassing the shims.
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_C_COMPILER:=clang",
              "-DCMAKE_C_COMPILER:=#{which(ENV.cc)}"
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_CXX_COMPILER:=clang++",
              "-DCMAKE_CXX_COMPILER:=#{which(ENV.cxx)}"

    # Fix lldb Python module not being installed (needed for `swift repl`)
    inreplace workspace/"llvm-project/lldb/cmake/caches/Apple-lldb-macOS.cmake",
              "repl_swift",
              "lldb-python-scripts \\0"

    # Fix Linux RPATH for Swift Foundation
    if OS.linux?
      inreplace workspace/"swift-corelibs-foundation/CMakeLists.txt",
                '"$ORIGIN"',
                "\"$ORIGIN:#{ENV["HOMEBREW_RPATH_PATHS"]}\""
    end

    extra_cmake_options = if OS.mac?
      %W[
        -DSQLite3_INCLUDE_DIR=#{MacOS.sdk_for_formula(self).path}/usr/include
        -DSQLite3_LIBRARY=#{MacOS.sdk_for_formula(self).path}/usr/lib/libsqlite3.tbd
      ]
    else
      []
    end

    # Inject our CMake args into the SwiftPM build
    inreplace workspace/"swiftpm/Utilities/bootstrap",
              '"-DCMAKE_BUILD_TYPE:=Debug",',
              "\"-DCMAKE_BUILD_TYPE:=Release\", \"#{extra_cmake_options.join('", "')}\","
    # and swift-driver's build
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "base_cmake_flags = []",
              "base_cmake_flags = [\"#{extra_cmake_options.join('", "')}\"]"

    mkdir build do
      # List of components to build
      swift_components = %w[
        autolink-driver compiler clang-resource-dir-symlink
        libexec tools editor-integration toolchain-tools
        license sourcekit-inproc sourcekit-xpc-service
        swift-remote-mirror swift-remote-mirror-headers stdlib
        static-mirror-lib
      ]
      llvm_components = %w[
        llvm-ar llvm-nm llvm-ranlib llvm-cov llvm-profdata
        llvm-objdump llvm-objcopy llvm-symbolizer IndexStore
        clang clang-resource-headers builtins runtimes
        clangd clang-features-file libclang lld LTO
      ]

      if OS.mac?
        swift_components << "back-deployment"
        llvm_components << "dsymutil"
      end
      swift_components << "sdk-overlay" if OS.linux?

      args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --no-assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --swiftdocc --indexstore-db --sourcekit-lsp
        --swift-testing --swift-testing-macros
        --jobs=#{ENV.make_jobs}
        --verbose-build

        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --lldb-configure-tests=0
        --lldb-extra-cmake-args=-DPython3_EXECUTABLE=#{python3}
        --skip-build-benchmarks
        --build-swift-private-stdlib=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-static-linux-config
        --install-swiftpm
        --install-swift-driver
        --install-swiftsyntax
        --install-swiftdocc
        --install-sourcekit-lsp
        --install-swift-testing
        --install-swift-testing-macros
      ]

      extra_swift_cmake_options = ["-DSWIFT_INCLUDE_TEST_BINARIES=OFF"]

      if OS.mac?
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --darwin-deployment-version-osx=#{MacOS.version}
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=x86_64;arm64
          --lldb-use-system-debugserver
        ]
        args << "--swift-enable-backtracing=0" if MacOS.version < :sonoma
        extra_swift_cmake_options += %W[
          -DSWIFT_STANDARD_LIBRARY_SWIFT_FLAGS=-disable-sandbox
          -DSWIFT_HOST_LIBRARIES_RPATH=#{loader_path}
        ]
        extra_llvm_cmake_options = ["-DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=OFF"]
        %w[BUILTINS RUNTIMES].product(%w[IOS TVOS WATCHOS XROS]).each do |stage, platform|
          extra_llvm_cmake_options <<
            "-D#{stage}_#{Hardware::CPU.arch}-apple-darwin_COMPILER_RT_ENABLE_#{platform}=OFF"
        end
        args << "--extra-llvm-cmake-options=#{extra_llvm_cmake_options.join(" ")}"

        ENV.remove "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("sqlite")
        ENV.remove "PKG_CONFIG_PATH", formula_opt_lib("sqlite")/"pkgconfig"
      end
      if OS.linux?
        # List of valid values in class StdlibDeploymentTarget in
        # utils/swift_build_support/swift_build_support/targets.py
        arch = Hardware::CPU.arm64? ? "aarch64" : Hardware::CPU.arch

        args += %W[
          --libcxx=0
          --foundation
          --libdispatch
          --xctest

          --host-target=linux-#{arch}
          --stdlib-deployment-targets=linux-#{arch}
          --build-swift-static-stdlib
          --build-swift-static-sdk-overlay
          --install-foundation
          --install-libdispatch
          --install-xctest
        ]

        # For XCTest (https://github.com/swiftlang/swift-corelibs-xctest/issues/432) and sourcekitd-repl
        # XCTest may be fixed in Swift 6.4.
        rpaths = [loader_path, rpath, rpath(target: lib/"swift/linux")]
        extra_cmake_options << "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"

        ENV.prepend_path "PATH", workspace/"bootstrap/usr/bin"

        # Bootstrap will be linked against system ncurses so point it to ours.
        # This unfortunately assumes that they are ABI compatible.
        ENV.prepend_path "LD_LIBRARY_PATH", HOMEBREW_PREFIX/"lib"

        # The installed swiftc bypasses our shim, so expose `-lcurses` on its link path.
        ENV.prepend_path "LIBRARY_PATH", HOMEBREW_PREFIX/"lib"

        # Use lld as Ubuntu 22.04 gold failed with "undefined symbol: _swift_registerConcurrencyRuntime".
        # We no longer include gold in `binutils` while bfd is less tested upstream and increases build time.
        ENV.prepend_path "PATH", formula_opt_bin("lld")
        args << "--use-linker=lld"
      end

      args << "--extra-cmake-options=#{extra_cmake_options.join(" ")}"
      args << "--extra-swift-cmake-options=#{extra_swift_cmake_options.join(" ")}"

      system "#{workspace}/swift/utils/build-script", *args
    end

    if OS.mac?
      # Prebuild modules for faster first startup.
      ENV["SWIFT_EXEC"] = "#{prefix}#{install_prefix}/bin/swiftc"
      MacOS.sdk_locator.all_sdks.each do |sdk|
        # FIXME: trying to prebuild macOS 27 SDK modules errors on MobileGestaltPrivate and arm64e.x1.
        # When limiting to `-core` and patching in arm64e.x1, it still fails but without any error.
        next if sdk.version >= 27

        system "#{prefix}#{install_prefix}/bin/swift", "build-sdk-interfaces",
               "-sdk", sdk.path,
               "-o", "#{prefix}#{install_prefix}/lib/swift/macosx/prebuilt-modules",
               "-log-path", logs/"build-sdk-interfaces",
               "-v"
      end

      # Remove `swift-backtrace` on macOS without system /usr/lib/swift/libswiftRuntime.dylib
      rm "#{prefix}#{install_prefix}/libexec/swift/macosx/swift-backtrace" if MacOS.version < :tahoe
    else
      # Strip debugging info to make the bottle relocatable.
      binaries_to_strip = Pathname.glob("#{prefix}#{install_prefix}/{bin,lib}/**/*").select do |f|
        f.file? && f.elf?
      end
      system "strip", "--strip-debug", "--preserve-dates", *binaries_to_strip
    end

    bin.install_symlink Dir["#{prefix}#{install_prefix}/bin/{swift,sil,sourcekit}*"]
    man1.install_symlink "#{prefix}#{install_prefix}/share/man/man1/swift.1"
    elisp.install_symlink "#{prefix}#{install_prefix}/share/emacs/site-lisp/swift-mode.el"
    doc.install_symlink Dir["#{prefix}#{install_prefix}/share/doc/swift/*"]

    rewrite_shebang detected_python_shebang, *Dir["#{prefix}#{install_prefix}/bin/*.py"]
  end

  def caveats
    on_macos do
      <<~EOS
        An Xcode toolchain has been installed to:
          #{opt_prefix}/Swift-#{version.major_minor}.xctoolchain

        This can be symlinked for use within Xcode:
          ln -s #{opt_prefix}/Swift-#{version.major_minor}.xctoolchain ~/Library/Developer/Toolchains/Swift-#{version.major_minor}.xctoolchain
      EOS
    end
  end

  test do
    ENV.delete "CPATH" if OS.mac?

    # Don't use global cache which is long-lasting and often requires clearing.
    module_cache = testpath/"ModuleCache"
    module_cache.mkdir

    (testpath/"test.swift").write <<~'SWIFT'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    SWIFT
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath/"foundation-test.swift").write <<~'SWIFT'
      import Foundation

      let swifty = URLComponents(string: "https://www.swift.org")!
      print("\(swifty.host!)")
    SWIFT
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v foundation-test.swift")
    assert_match "www.swift.org\n", output

    # Test compiler
    system bin/"swiftc", "-module-cache-path", module_cache, "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output("./foundation-test 2>&1") # check stderr too for dyld errors
    assert_equal "www.swift.org\n", output

    # Test Swift Package Manager
    ENV["SWIFTPM_MODULECACHE_OVERRIDE"] = module_cache
    mkdir "swiftpmtest" do
      system bin/"swift", "package", "init", "--type=executable"
      cp "../foundation-test.swift", "Sources/swiftpmtest/swiftpmtest.swift"
      system bin/"swift", "build", "--verbose", "--disable-sandbox"
      assert_match "www.swift.org\n", shell_output("#{bin}/swift run --disable-sandbox")
    end

    # Make sure the default resource directory is not using a Cellar path
    default_resource_dir = JSON.parse(shell_output("#{bin}/swift -print-target-info"))["paths"]["runtimeResourcePath"]
    expected_resource_dir = if OS.mac?
      opt_prefix/"Swift-#{version.major_minor}.xctoolchain/usr/lib/swift"
    else
      opt_libexec/"usr/lib/swift"
    end.to_s
    assert_equal expected_resource_dir, default_resource_dir
  end
end

__END__
diff --git a/lib/Tooling/libSwiftScan/CMakeLists.txt b/lib/Tooling/libSwiftScan/CMakeLists.txt
index cd68ea874a6..fff338411f4 100644
--- a/lib/Tooling/libSwiftScan/CMakeLists.txt
+++ b/lib/Tooling/libSwiftScan/CMakeLists.txt
@@ -42,6 +42,10 @@ if(SWIFT_HOST_VARIANT_SDK MATCHES "LINUX|ANDROID|OPENBSD|FREEBSD" AND BOOTSTRAPP
     TARGET libSwiftScan
     APPEND PROPERTY INSTALL_RPATH "$ORIGIN/../${SWIFT_SDK_${SWIFT_HOST_VARIANT_SDK}_LIB_SUBDIR}"
   )
+  set_property(
+    TARGET libSwiftScan
+    APPEND PROPERTY INSTALL_RPATH "$ORIGIN/../../${SWIFT_SDK_${SWIFT_HOST_VARIANT_SDK}_LIB_SUBDIR}"
+  )
 endif()

 if(SWIFT_BUILD_SWIFT_SYNTAX)
diff --git a/stdlib/public/RuntimeModule/CMakeLists.txt b/stdlib/public/RuntimeModule/CMakeLists.txt
--- a/stdlib/public/RuntimeModule/CMakeLists.txt
+++ b/stdlib/public/RuntimeModule/CMakeLists.txt
@@ -187,7 +187,7 @@
     foreach(arch ${sdk_supported_archs})
       set(base_target "swiftRuntime-${SWIFT_SDK_${sdk}_LIB_SUBDIR}-${arch}")
       foreach(target ${base_target} ${base_target}-static)
-        if(TARGET ${target})
+        if(TARGET ${target} AND arch IN_LIST SWIFT_SDK_${sdk}_ARCHITECTURES)
           if(sdk STREQUAL "WINDOWS")
             message(STATUS "Using get-cpu-context-${arch}.asm for target ${target}")
             target_sources(${target}
