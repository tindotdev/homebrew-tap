class DictateCli < Formula
  desc "One-shot CLI for dictate: record, transcribe, and copy to clipboard"
  homepage "https://github.com/tindotdev/dictate"
  version "1.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.1/dictate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "654f3a559f2eb78e375dd16f90e75cfad826b2791403d357d7b0c1ce855cbdbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.1/dictate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f0a610462c7165df88f3f038374fc0838aa0c2ceca419e9ed0e40e4ad4cb68c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.1/dictate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "29a554de6d6fcfe763d9438ea4be064c28cea263bee08e632490c4a27955f80e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.8.1/dictate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d4824e7aad5cf66a944a1c1da58b01fa28e5d5a98a1ccbe78d092c6c18f43e1"
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
