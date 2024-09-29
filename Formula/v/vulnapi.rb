# typed: false
# frozen_string_literal: true

class Vulnapi < Formula
  desc "Scan your APIs for security vulnerabilities and weaknesses"
  homepage "https://vulnapi.cerberauth.com/"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cerberauth/vulnapi/releases/download/v0.8.0/vulnapi_Darwin_x86_64.tar.gz"
      sha256 "9df50027c130f7bd03d67f3c138e6f0e480e97c9dd577aad1b4789a88ea9bc2d"

      def install
        bin.install "vulnapi"
      end
    end
    on_arm do
      url "https://github.com/cerberauth/vulnapi/releases/download/v0.8.0/vulnapi_Darwin_arm64.tar.gz"
      sha256 "3648acba1dd0a9ec803e95243fe6c31ada7fc825306574ea99796875fa90e464"

      def install
        bin.install "vulnapi"
      end
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/cerberauth/vulnapi/releases/download/v0.8.0/vulnapi_Linux_x86_64.tar.gz"
        sha256 "f8150af17f9a8e13360ae12029df9bd83291151b96bbb017c97286609e1f1bf9"

        def install
          bin.install "vulnapi"
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/cerberauth/vulnapi/releases/download/v0.8.0/vulnapi_Linux_arm64.tar.gz"
        sha256 "33e6b5e75a4f950a727c005ae576d1367b8238b1c0f404592a505242909bfe37"

        def install
          bin.install "vulnapi"
        end
      end
    end
  end

  test do
    assert_match "vulnapi version #{version}", shell_output("#{bin}/vulnapi version")
    assert_match "Usage", shell_output("#{bin}/vulnapi --help")
  end
end
