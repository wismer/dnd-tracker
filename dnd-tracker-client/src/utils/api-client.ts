// types.ts - Type definitions
export interface Adventure {
  id: number
  name: string
  description?: string
  type: 'campaign' | 'one-shot'
  status: 'planning' | 'active' | 'completed' | 'on-hold'
  created_at: string
  updated_at: string
  locations?: Location[]
  npcs?: Npc[]
}

export interface Location {
  id: number
  adventure_id: number
  name: string
  description?: RichTextContent
  notes?: RichTextContent
  reference_key?: string
  created_at: string
  updated_at: string
  points_of_interest?: PointOfInterest[]
  npcs?: Npc[]
}

export interface Npc {
  id: number
  adventure_id: number
  name: string
  description?: RichTextContent
  stats?: Record<string, any>
  abilities?: string[]
  notes?: RichTextContent
  reference_key?: string
  created_at: string
  updated_at: string
  locations?: Location[]
}

export interface PointOfInterest {
  id: number
  location_id: number
  name: string
  description?: RichTextContent
  skill_checks?: Record<string, SkillCheck>
  notes?: RichTextContent
  type: string
  reference_key?: string
  created_at: string
  updated_at: string
}

export interface SkillCheck {
  dc: number
  success: string
  failure: string
  skill?: string
}

export interface RichTextContent {
  type: string
  content: RichTextNode[]
}

export interface RichTextNode {
  type: string
  content?: RichTextNode[]
  text?: string
  attrs?: Record<string, any>
}

export interface Reference {
  id: number
  name: string
  reference_key: string
  type: 'location' | 'npc' | 'poi'
}

export interface ApiResponse<T> {
  data: T
}

export interface ApiError {
  errors: Record<string, string[]>
}

// Create types for request payloads
export type CreateAdventurePayload = Omit<
  Adventure,
  'id' | 'created_at' | 'updated_at' | 'locations' | 'npcs'
>
export type UpdateAdventurePayload = Partial<CreateAdventurePayload>

export type CreateLocationPayload = Omit<
  Location,
  'id' | 'adventure_id' | 'created_at' | 'updated_at' | 'points_of_interest' | 'npcs'
>
export type UpdateLocationPayload = Partial<CreateLocationPayload>

export type CreateNpcPayload = Omit<
  Npc,
  'id' | 'adventure_id' | 'created_at' | 'updated_at' | 'locations'
>
export type UpdateNpcPayload = Partial<CreateNpcPayload>

export type CreatePointOfInterestPayload = Omit<
  PointOfInterest,
  'id' | 'location_id' | 'created_at' | 'updated_at'
>
export type UpdatePointOfInterestPayload = Partial<CreatePointOfInterestPayload>

// api-client.ts - Main API client class
export class DndTrackerApiClient {
  private baseUrl: string
  private headers: HeadersInit

  constructor(baseUrl: string = 'http://localhost:4000/api/v1') {
    this.baseUrl = baseUrl
    this.headers = {
      Accept: 'application/json',
    }
  }

  private async request<T>(endpoint: string, options?: RequestInit): Promise<T> {
    const url = `${this.baseUrl}${endpoint}`
    const config: RequestInit = {
      headers: this.headers,
      ...options,
    }

    try {
      const response = await fetch(url, config)

      if (!response.ok) {
        if (response.headers.get('content-type')?.includes('application/json')) {
          const errorData = (await response.json()) as ApiError
          throw new ApiClientError(`HTTP ${response.status}`, response.status, errorData)
        }
        throw new ApiClientError(`HTTP ${response.status}: ${response.statusText}`, response.status)
      }

      // Handle 204 No Content responses
      if (response.status === 204) {
        return undefined as T
      }

      return await response.json()
    } catch (error) {
      if (error instanceof ApiClientError) {
        throw error
      }
      throw new ApiClientError(
        `Network error: ${error instanceof Error ? error.message : 'Unknown error'}`,
      )
    }
  }

  // Adventures API
  async getAdventures(): Promise<Adventure[]> {
    const response = await this.request<ApiResponse<Adventure[]>>('/adventures')
    return response.data
  }

  async getAdventure(id: number): Promise<Adventure> {
    const response = await this.request<ApiResponse<Adventure>>(`/adventures/${id}`)
    return response.data
  }

  async createAdventure(adventure: CreateAdventurePayload): Promise<Adventure> {
    const response = await this.request<ApiResponse<Adventure>>('/adventures', {
      method: 'POST',
      body: JSON.stringify({ adventure }),
    })
    return response.data
  }

  async updateAdventure(id: number, adventure: UpdateAdventurePayload): Promise<Adventure> {
    const response = await this.request<ApiResponse<Adventure>>(`/adventures/${id}`, {
      method: 'PUT',
      body: JSON.stringify({ adventure }),
    })
    return response.data
  }

  async deleteAdventure(id: number): Promise<void> {
    await this.request<void>(`/adventures/${id}`, {
      method: 'DELETE',
    })
  }

  // Locations API
  async getLocations(adventureId: number): Promise<Location[]> {
    const response = await this.request<ApiResponse<Location[]>>(
      `/adventures/${adventureId}/locations`,
    )
    return response.data
  }

  async getLocation(id: number): Promise<Location> {
    const response = await this.request<ApiResponse<Location>>(`/locations/${id}`)
    return response.data
  }

  async createLocation(adventureId: number, location: CreateLocationPayload): Promise<Location> {
    const response = await this.request<ApiResponse<Location>>(
      `/adventures/${adventureId}/locations`,
      {
        method: 'POST',
        body: JSON.stringify({ location }),
      },
    )
    return response.data
  }

  async updateLocation(id: number, location: UpdateLocationPayload): Promise<Location> {
    const response = await this.request<ApiResponse<Location>>(`/locations/${id}`, {
      method: 'PUT',
      body: JSON.stringify({ location }),
    })
    return response.data
  }

  async deleteLocation(id: number): Promise<void> {
    await this.request<void>(`/locations/${id}`, {
      method: 'DELETE',
    })
  }

  // NPCs API
  async getNpcs(adventureId: number): Promise<Npc[]> {
    const response = await this.request<ApiResponse<Npc[]>>(`/adventures/${adventureId}/npcs`)
    return response.data
  }

  async getNpc(id: number): Promise<Npc> {
    const response = await this.request<ApiResponse<Npc>>(`/npcs/${id}`)
    return response.data
  }

  async createNpc(adventureId: number, npc: CreateNpcPayload): Promise<Npc> {
    const response = await this.request<ApiResponse<Npc>>(`/adventures/${adventureId}/npcs`, {
      method: 'POST',
      body: JSON.stringify({ npc }),
    })
    return response.data
  }

  async updateNpc(id: number, npc: UpdateNpcPayload): Promise<Npc> {
    const response = await this.request<ApiResponse<Npc>>(`/npcs/${id}`, {
      method: 'PUT',
      body: JSON.stringify({ npc }),
    })
    return response.data
  }

  async deleteNpc(id: number): Promise<void> {
    await this.request<void>(`/npcs/${id}`, {
      method: 'DELETE',
    })
  }

  // Points of Interest API
  async getPointsOfInterest(locationId: number): Promise<PointOfInterest[]> {
    const response = await this.request<ApiResponse<PointOfInterest[]>>(
      `/locations/${locationId}/points_of_interest`,
    )
    return response.data
  }

  async getPointOfInterest(id: number): Promise<PointOfInterest> {
    const response = await this.request<ApiResponse<PointOfInterest>>(`/points_of_interest/${id}`)
    return response.data
  }

  async createPointOfInterest(
    locationId: number,
    poi: CreatePointOfInterestPayload,
  ): Promise<PointOfInterest> {
    const response = await this.request<ApiResponse<PointOfInterest>>(
      `/locations/${locationId}/points_of_interest`,
      {
        method: 'POST',
        body: JSON.stringify({ point_of_interest: poi }),
      },
    )
    return response.data
  }

  async updatePointOfInterest(
    id: number,
    poi: UpdatePointOfInterestPayload,
  ): Promise<PointOfInterest> {
    const response = await this.request<ApiResponse<PointOfInterest>>(`/points_of_interest/${id}`, {
      method: 'PUT',
      body: JSON.stringify({ point_of_interest: poi }),
    })
    return response.data
  }

  async deletePointOfInterest(id: number): Promise<void> {
    await this.request<void>(`/points_of_interest/${id}`, {
      method: 'DELETE',
    })
  }

  // Location-NPC associations
  async addNpcToLocation(locationId: number, npcId: number): Promise<void> {
    await this.request<void>(`/locations/${locationId}/npcs/${npcId}`, {
      method: 'POST',
    })
  }

  async removeNpcFromLocation(locationId: number, npcId: number): Promise<void> {
    await this.request<void>(`/locations/${locationId}/npcs/${npcId}`, {
      method: 'DELETE',
    })
  }

  // References for rich text editor
  async getReferences(adventureId: number): Promise<Reference[]> {
    const response = await this.request<ApiResponse<Reference[]>>(
      `/adventures/${adventureId}/references`,
    )
    return response.data
  }
}

// Custom error class for API errors
export class ApiClientError extends Error {
  constructor(
    message: string,
    public status?: number,
    public errors?: ApiError,
  ) {
    super(message)
    this.name = 'ApiClientError'
  }

  get isValidationError(): boolean {
    return this.status === 422 && !!this.errors
  }

  get isNotFoundError(): boolean {
    return this.status === 404
  }

  get isServerError(): boolean {
    return !!this.status && this.status >= 500
  }
}

// Factory function for creating API client instance
export function createApiClient(baseUrl?: string): DndTrackerApiClient {
  return new DndTrackerApiClient(baseUrl)
}

// Helper functions for rich text content
export const RichTextHelpers = {
  // Create empty rich text content
  createEmpty(): RichTextContent {
    return {
      type: 'doc',
      content: [],
    }
  },

  // Create simple text content
  createText(text: string): RichTextContent {
    return {
      type: 'doc',
      content: [
        {
          type: 'paragraph',
          content: [
            {
              type: 'text',
              text,
            },
          ],
        },
      ],
    }
  },

  // Extract plain text from rich text content
  extractPlainText(richText?: RichTextContent): string {
    if (!richText?.content) return ''

    const extractFromNodes = (nodes: RichTextNode[]): string => {
      return nodes
        .map((node) => {
          if (node.type === 'text') {
            return node.text || ''
          }
          if (node.type === 'reference') {
            return `#${node.attrs?.key || ''}`
          }
          if (node.content) {
            return extractFromNodes(node.content)
          }
          return ''
        })
        .join('')
    }

    return extractFromNodes(richText.content)
  },

  // Check if rich text content is empty
  isEmpty(richText?: RichTextContent): boolean {
    return (
      !richText?.content?.length ||
      richText.content.every(
        (node) => !node.content?.length || node.content.every((child) => !child.text?.trim()),
      )
    )
  },
}

// Usage example and factory
export default {
  DndTrackerApiClient,
  createApiClient,
  ApiClientError,
  RichTextHelpers,
}
