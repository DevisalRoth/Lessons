//
//  ContentView.swift
//  Lessons
//
//  Created by Visalroth on 9/1/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: NotificationTab = .transactions
    var body: some View {
        VStack(spacing: 16) {
            HeaderView()
                .padding(.horizontal)
            SegmentedTabs(selection: $selection, tabs: NotificationTab.allCases)
                .padding(.horizontal)
            TabView(selection: $selection) {
                TransactionsView()
                    .tag(NotificationTab.transactions)
                AnnouncementsView()
                    .tag(NotificationTab.announcements)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.top, 16)
    }
}

#Preview {
    ContentView()
}

enum NotificationTab: Int, CaseIterable, Hashable, Identifiable {
    case transactions
    case announcements
    var id: Int { rawValue }
    var title: String {
        switch self {
        case .transactions: return "Transactions"
        case .announcements: return "Announcements"
        }
    }
}

struct HeaderView: View {
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            Text("Notifications")
                .font(.headline)
        }
        .frame(height: 28)
    }
}

struct SegmentedTabs: View {
    @Binding var selection: NotificationTab
    let tabs: [NotificationTab]
    @Namespace private var ns
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width / CGFloat(max(tabs.count, 1))
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemFill))
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(.separator), lineWidth: 1)
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: width)
                    .offset(x: CGFloat(index(of: selection)) * width)
                    .animation(.easeInOut(duration: 0.2), value: selection)
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(.separator).opacity(0.6), lineWidth: 1)
                    .frame(width: width)
                    .offset(x: CGFloat(index(of: selection)) * width)
                    .animation(.easeInOut(duration: 0.2), value: selection)
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.self) { tab in
                        Button {
                            selection = tab
                        } label: {
                            Text(tab.title)
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                        }
                        .foregroundStyle(selection == tab ? Color.primary : Color.secondary)
                    }
                }
            }
        }
        .frame(height: 36)
    }
    
    private func index(of tab: NotificationTab) -> CGFloat {
        CGFloat(tabs.firstIndex(of: tab) ?? 0)
    }
}

struct TransactionsView: View {
    var body: some View {
        List {
            Section(header: Text("Today")) {
                ForEach(0..<8, id: \.self) { i in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(Color(.systemGray5))
                            Text("A")
                                .font(.caption).bold()
                        }
                        .frame(width: 36, height: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Paid to VISALROTH CHOU")
                                .font(.subheadline).bold()
                            Text("2,000 KHR is paid from your account ••••4698.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("03:55 PM")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct Announcement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageURL: String
    let date: String
}

struct AnnouncementsView: View {
    @State private var selectedAnnouncement: Announcement?
    
    let announcements = [
        Announcement(
            title: "Celebrate Lunar New Year on Your Home Screen",
            description: "Refresh your Home Background with festive elegance and welcome a year of luck and prosperity in every tap.",
            imageURL: "https://images.unsplash.com/photo-1576489912509-32820ee212aa?q=80&w=800&auto=format&fit=crop",
            date: "14 Feb 2026, 10:12 AM"
        ),
        Announcement(
            title: "GOAT - The Greatest of All Time",
            description: "Experience the epic journey of a legend in this groundbreaking animation. Streaming now on all platforms!",
            imageURL: "https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=800&auto=format&fit=crop",
            date: "Today, 02:51 PM"
        ),
        Announcement(
            title: "Cartoon Adventure: The Lost Kingdom",
            description: "Join our favorite characters on a new magical adventure to save their home from a mysterious force.",
            imageURL: "https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=800&auto=format&fit=crop",
            date: "11 Feb 2026, 03:32 PM"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(announcements) { announcement in
                    Button {
                        selectedAnnouncement = announcement
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            AsyncImage(url: URL(string: announcement.imageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ZStack {
                                    Color(.systemGray5)
                                    ProgressView()
                                }
                            }
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(announcement.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Text(announcement.date.suffix(8))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Text(announcement.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal, 4)
                        }
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
        .sheet(item: $selectedAnnouncement) { announcement in
            AnnouncementDetailView(announcement: announcement)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct AnnouncementDetailView: View {
    let announcement: Announcement
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: announcement.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(16)
            
            VStack(alignment: .center, spacing: 16) {
                Text(announcement.title)
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(announcement.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                Button {
                    // Action for personalization
                } label: {
                    Text("Personalize Now")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .padding(.top, 8)
        }
    }
}
