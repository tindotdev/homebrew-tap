class DictateCli < Formula
  desc "One-shot CLI for dictate: record, transcribe, and copy to clipboard"
  homepage "https://github.com/tindotdev/dictate"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.3.0/dictate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4e71664e95b96ed8f3a5cf31ed761ec2f6331cfea5e3eceea02fe6890e6a7ea2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.3.0/dictate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "96d63d40d56a4edab2daca6e28e922dc79a510cee69385644edaa66886d9b80f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.3.0/dictate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f59f0386f4608453e2a87683d6b14694ad0ccb3622bcb8a3ad80fb367573a93d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.3.0/dictate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "245f8d3f7ca196ca2cddcbdedf2f6be03bce66312cd12ba13ca85157b5d0183a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dictate" if OS.mac? && Hardware::CPU.arm?
    bin.install "dictate" if OS.mac? && Hardware::CPU.intel?
    bin.install "dictate" if OS.linux? && Hardware::CPU.arm?
    bin.install "dictate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
